extends Control

@export var main: BattleScene

@onready var enemies_devoured: Label = $Control/EnemiesDevoured
@onready var progress_towards_next_size: Label = $Control/ProgressTowardsNextSize
@onready var progress_bar: ProgressBar = $Control/ProgressBar
@onready var kills: Label = $Control2/Kills
@onready var money_earned: Label = $Control2/MoneyEarned
@onready var win_bonus: Label = $WinBonus
@onready var skip_or_continue: Button = $SkipOrContinue

var skipping := false
var allow_input := false

signal next_stat
var finished_showing_stats := false

func summarize_stats(won: bool):
	var devoured_count := main.devoured_count
	var kill_count = main.kill_count
	
	enemies_devoured.text = "Enemies Devoured: %s" % str(devoured_count)
	var diff = Global.sav.devours_needed_for_next_size - Global.sav.devours_progress
	update_progress_bar()
	
	if diff == 0:
		progress_towards_next_size.text = "Advance story to get to next size!"
	else:
		progress_towards_next_size.text = "Devour %s more to grow to the next size!" % diff  
	
	kills.text = "Kills: %s" % str(kill_count)
	money_earned.text = "Money Earned: 0"
	
	win_bonus.text = "Win Bonus: ..."
	
	skip_or_continue.text = "Skip"
	
	if not skipping and not diff == 0:
		await next_stat
	
	if not diff == 0:
		for i in range(devoured_count):
			Global.sav.devours_progress += 1
			diff = Global.sav.devours_needed_for_next_size - Global.sav.devours_progress
			if diff == 0:
				progress_towards_next_size.text = "Advance story to get to next size!"
				Global.sav.devours_progress = 0
				Global.sav.devours_needed_for_next_size = 0
				Global.sav.size += 1
				update_progress_bar()
				break  
			else:
				progress_towards_next_size.text = "Devour %s more to grow to the next size!" % diff
				update_progress_bar()
			
			if not skipping:
				await Methods.wait(0.1)
	
	if not skipping:
		await next_stat
	
	var money_earned_count := 0
	for i in range(kill_count):
		money_earned_count += 1
		money_earned.text = "Money Earned: %s" % str(money_earned_count)
		
		if not skipping:
			await Methods.wait(0.1)
	
	if not skipping:
		await next_stat
	
	if won:
		var possible_bonuses = ["1x Cured Ham", "1x Flesh", "1x Goat's Blood", "5x Money"]
		var bonus_index = randi_range(0,3)
		win_bonus.text = "Win Bonus: %s" % possible_bonuses[bonus_index]
		match bonus_index:
			0:
				Global.sav.cured_ham += 1
			1: 
				Global.sav.flesh += 1
			2: 
				Global.sav.goats_blood += 1
			3:
				Global.sav.money += 5
	else:
		win_bonus.text = "Escaped! No bonus given."
	
	skip_or_continue.text = "Continue"
	finished_showing_stats = true

func allow_input_true():
	allow_input = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") or event.is_action_pressed("ui_accept"):
		if allow_input:
			next_stat.emit()

func update_progress_bar():
	progress_bar.max_value = Global.sav.devours_needed_for_next_size
	progress_bar.value = Global.sav.devours_progress

func _on_skip_or_continue_pressed() -> void:
	if finished_showing_stats:
		Methods.return_to_overworld(true)
	else:
		skipping = true
		next_stat.emit()

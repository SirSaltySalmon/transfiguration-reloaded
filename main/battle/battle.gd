class_name BattleScene
extends Node3D

@export var ui: BattleUI
@export var cam: BattleCam
@export var anim: AnimationPlayer
@export var skills: SkillCenter
@export var target: TargetSelection
@export var dialogue: DialogueResource
@export var combat_balloon: PackedScene

var initializing_chars = false
var loading_new_char = false
var current_char_path: String
var char_load_status
signal finished_loading

var bt_enemy_party: Array[String]
var all_allies: Array[BattleCharacter] = []
var all_enemies: Array[BattleCharacter] = []
var all_chars: Array[BattleCharacter] = []

var devoured_count := 0

var current_char: BattleCharacter = null

var dialogue_queue := []
var flavor_queue := ""

var first_player_turn := true ## generic flag for flavor text

func _process(_delta: float) -> void:
	if initializing_chars:
		handle_char_loading()

func handle_char_loading():
	if loading_new_char:
		char_load_status = ResourceLoader.load_threaded_get_status(current_char_path)
		if char_load_status == ResourceLoader.THREAD_LOAD_LOADED:
			loading_new_char = false
			finished_loading.emit()

func _ready() -> void:
	Methods.current_scene = self
	await initialize_chars()
	await initialize_misc()
	await start_anim()
	initialize_turn_sys()
	action()

#region Loading and instantiating characters

func initialize_chars():
	initializing_chars = true
	await initialize_allies()
	await initialize_enemies()
	initializing_chars = false
	return

func initialize_misc():
	if Global.battle_type == 2:
		dialogue_queue.append("tutorial")
	elif Global.battle_type == 3:
		dialogue_queue.append("shadow_wizards")
	return

func load_chars(holders: Node, party: Array):
	var party_index = 0
	
	for holder in holders.get_children():
		var id = party[party_index]
		current_char_path = get_char_path(id)
		
		ResourceLoader.load_threaded_request(current_char_path)
		loading_new_char = true
		await finished_loading
		
		var new_char = ResourceLoader.load_threaded_get(current_char_path)
		new_char = new_char.instantiate()
		holder.add_child(new_char)
		
		if new_char.ally:
			all_allies.append(new_char)
		else:
			all_enemies.append(new_char)
		
		party_index += 1
	return

func initialize_allies():
	%AllyHolders1.hide()
	%AllyHolders2.hide()
	%AllyHolders3.hide()
	
	var size = str(Global.bt_party.size())
	var ally_holders = get_node("%AllyHolders" + size)
	ally_holders.show()
	
	await load_chars(ally_holders, Global.bt_party)
	
	return

func initialize_enemies():
	%EnemyHolders1.hide()
	%EnemyHolders2.hide()
	%EnemyHolders3.hide()
	
	var possible_enemies
	match Global.battle_type:
		0: possible_enemies = ["knight_low", "elf_low", "wizard_low"]
		1: possible_enemies = ["knight_high", "elf_high", "wizard_high"]
		2: possible_enemies = ["knight_low"]
		3: possible_enemies = ["shadow_wizard_a", "shadow_wizard_b"]
		4: possible_enemies = ["hannes"]
		_: printerr("Invalid battle type")
	
	var bt_enemy_party = get_random_enemies(possible_enemies) if Global.battle_type in [0, 1] else possible_enemies
	var size = str(bt_enemy_party.size())
	var enemy_holders = get_node("%EnemyHolders" + size)
	enemy_holders.show()
	
	await load_chars(enemy_holders, bt_enemy_party)
	return

func get_random_enemies(possible_enemies):
	var num_enemies = randi() % 2 + 2
	
	var shuffled_enemies = possible_enemies.duplicate()
	shuffled_enemies.shuffle()
	
	return shuffled_enemies.slice(0, num_enemies)

func get_char_path(id: String):
	return "res://main/battle/character/bt_" + id + ".tscn"

func get_alive_chars():
	return all_chars.filter(func(char): return not char.health.dead)

func get_alive_allies():
	return all_allies.filter(func(ally): return not ally.health.dead)

func get_dead_allies():
	return all_allies.filter(func(ally): return ally.health.dead)

func get_alive_enemies():
	return all_enemies.filter(func(enemy): return not enemy.health.dead)

func get_dead_enemies():
	return all_enemies.filter(func(enemy): return not enemy.health.dead)

#endregion

#region Main game loop

func initialize_turn_sys():
	Broadcaster.connect("ready_to_move", _on_char_ready)
	Broadcaster.connect("action_over", _on_action_over)

func action():
	all_chars = []
	all_chars.append_array(get_alive_allies())
	all_chars.append_array(get_alive_enemies())
	await dialogue_check() #This can be called manually in a skill to trigger it in between
	await wait_for_turn_ready()
	var died_from_effect = await current_char.health.trigger_all_effects()
	if died_from_effect:
		return
	current_char.visual.indicate(true)
	if current_char.ally:
		flavor_text_add()
		flavor_text_check()
		ui.change_to("options")
		
		if first_player_turn:
			first_player_turn = false
	else:
		current_char.use_basic_attack(target.random_target(get_alive_allies()))
		## TODO: Make the actual enemy AI
	return

func _on_action_over():
	current_char.visual.hide_indicator()
	current_char = null
	if get_alive_allies().is_empty():
		#play lose animation
		pass
	#reset camera to idle state
	if get_alive_enemies().is_empty():
		#play win animation
		pass
	#else, next turn
	ui.hide_move()
	cam.return_to_idle()
	action()

func wait_for_turn_ready():
	while current_char == null:
		for char in get_alive_chars():
			char.turn.increment()
		await Methods.wait(0.01)
	return

func _on_char_ready(character: BattleCharacter):
	current_char = character

func cancel_selection():
	cam.return_to_idle()
	ui.open()
	current_char.visual.indicate(true)

#endregion

#region In-Battle Text

func get_talker(talker: String) -> BattleCharacter:
	for char in all_chars:
		if char.name == talker:
			return char
	return null
	
func dialogue_check():
	if dialogue_queue.is_empty():
		return
	var title = dialogue_queue.pop_back()
	DialogueManager.show_dialogue_balloon_scene(combat_balloon, dialogue, title)
	
	await DialogueManager.dialogue_ended

func flavor_text_add():
	if Global.battle_type == 2 and first_player_turn:
		flavor_queue = "Now let's see what he tastes like."

func flavor_text_check():
	if flavor_queue.is_empty():
		return
	ui.flavor_text.write(flavor_queue)
	flavor_queue = ""

#endregion

#region Animations

func start_anim():
	ui.solid_color.show()
	ui.left_panel.hide()
	ui.right_panel.hide()
	anim.play("start_anim")
	await anim.animation_finished
	return

#endregion

class_name SaveGame
extends Resource

@export var first_version_opened : String
@export var last_version_opened : String
@export var last_unix_time_saved : int

#Overworld data
@export var size := 1:
	set(value):
		size = value
		devours_progress = 0
		var new_target = 0
		match value:
			1:
				new_target = 0 # eat body to advance
			2:
				new_target = 3 # FARM NORMALLY
			3:
				new_target = 0 # eat shadow wizards & golem to advance
			4:
				new_target = 0 # eat aristocratic wizards to advance
			5:
				new_target = 6 # FARM NORMALLY
			6:
				new_target = 0 # eat dragon to advance
			7:
				new_target = 0 # endgame
			_:
				new_target = 0
		devours_needed_for_next_size = new_target
		Methods.flags_changed.emit()
@export var devours_needed_for_next_size := 0
@export var devours_progress := 0
@export var current_area_id := "sewers"
@export var current_resource := "res://main/overworld/areas/sewers.tscn"
@export var random_battle_type := 0
@export var base_escape_chance := 80
@export var effective_escape_chance: int
@export var repellant_active := false

#Story flags
@export var cutscene_1 = false
@export var rat_talk_1 := false
@export var just_size_2 := false
@export var rat_talk_2 := false
@export var golem_talk_1 := false
@export var golem_talk_2 := false
@export var gob_rejection := false
@export var gob_assess := false
@export var gob_sells_grimoire := false
@export var shadow_wizards_defeated := false

#Items & money data
@export var cured_ham := 0
@export var flesh := 0
@export var goats_blood := 0
@export var money := 0
@export var repellant_owned := false

#Battle stats data
@export var bt_party := ["slime", "rat"]

@export var bt_reference := ["health", "basic attack dmg", "speed"]

#Storing these here rather than in the node because values might be modified throughout the game
@export var skills_data = {
	"Reference" : ["+Value", "Single Target?", "Enemy?", "Description", "Duration (optional)"],
	"Devour" : [10 , true, true, "Deals [color=red]VALUE Damage[/color] to an enemy, and [color=cyan]devours[/color] the enemy if they have [color=orange]20% health or less[/color], giving a bonus turn immediately."],
	"Toxic Bite": [20, true, true, "Deals [color=red]VALUE Damage[/color] to an enemy, [color=green]Poisoning[/color] them for DURATION turns.", 3],
	"Goop": [0, true, true, "Apply [color=cyan]Goop[/color] to an enemy, slowing their speed by 30% for DURATION turns.", 5],
	"Dap Up": [0, true, false, "Add [color=#1f93ff]action value[/color] equal to half your speed to an ally."]
}

#Use these skills ID, but fetch skill module path from dictionary in Methods
@export var bt_slime := [150, 20, 50]
@export var bt_slime_skills := ["Devour", "Goop", "", ""]
@export var bt_rat := [75, 30, 70]
@export var bt_rat_skills := ["Toxic Bite", "Dap Up", "", ""]
@export var bt_angel := [120, 20, 40]
@export var bt_angel_skills := ["Judgment", "Cure", "Haste", ""]

@export var bt_knight_low := [100, 30, 30]
@export var bt_elf_low := [70, 40, 60]

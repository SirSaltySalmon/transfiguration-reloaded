class_name SaveGame
extends Resource

@export var first_version_opened : String
@export var last_version_opened : String
@export var last_unix_time_saved : int

#Settings
@export var disable_screen_shake := false
@export var master_vol := 100.0
@export var sfx_vol := 100.0
@export var music_vol := 100.0

#Overworld data
@export var size := 7:
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
@export var repellant_active := true

#Story flags
@export var cutscene_1 = false
@export var rat_talk_1 := false
@export var just_size_2 := false
@export var rat_talk_2 := false
@export var tutorial_fight_complete := false
@export var golem_talk_1 := false
@export var golem_talk_2 := false
@export var gob_rejection := false
@export var gob_assess := false
@export var gob_sells_grimoire := false
@export var rat_comments_on_grimoire := false
@export var shadow_wizards_defeated := false
@export var shadow_1 := false
@export var shadow_2 := false
@export var shadow_3 := false
@export var angel_talk_1 := false
@export var rat_comments_on_posters := false
@export var angel_talk_2 := false
@export var jori_intro := false

@export var money_at_jori := 0

#Items & money data
@export var cured_ham := 0
@export var flesh := 0
@export var goats_blood := 0
@export var money := 0
@export var repellant_owned := false

@export var stock_dict = {
	"Health Upgrade" : 1,
	"Relentless Ridicule" : 1,
	"Benevolence" : 1,
	"Repellant" : 1,
}

#Battle stats data
@export var bt_party := ["rat", "slime", "angel"]

#Storing these here rather than in the node because values might be modified throughout the game
@export var skills_data = {
	"Reference" : ["+Value", "Single Target?", "Enemy?", "Description", "Duration (optional)"],
	"Devour" : [15 , true, true, "Deals [color=red]VALUE TRUE Damage[/color] to an enemy, and [color=cyan]devours[/color] the enemy if they have [color=orange]20% health or less[/color], giving a bonus turn immediately."],
	"Toxic Bite": [20, true, true, "Deals [color=red]VALUE Damage[/color] to an enemy, [color=green]Poisoning[/color] them for DURATION turns.", 3],
	"Goop": [0, true, true, "Apply [color=cyan]Goop[/color] to an enemy, [color=lightblue]slowing their speed by 30%[/color] for DURATION turns.", 5],
	"Dap Up": [0, true, false, "Add [color=#1f93ff]action value[/color] equal to half your speed to an ally."],
	"Judgment": [20, false, true, "Deals [color=red]VALUE Damage[/color] to 3 random enemy targets."],
	"Cure": [30, true, false, "Heals an ally for [color=green]VALUE Damage[/color] and relieves them of any negative effects."],
	"Bless": [30, false, false, "[color=lightblue]Raise speed by 30%[/color] for all allies for DURATION turns.", 5],
	"Band For Band": [20, false, true, "Deals [color=red]VALUE Damage[/color] to 3 random enemy targets."],
	"Relentless Ridicule": [20, true, true, "Deals [color=red]VALUE Damage[/color] to an enemy, causing them to [color=purple]take 25% extra damage[/color] for 3 turns.", 3],
	"Cross Slash": [10, false, true, "Deals [color=red]VALUE Damage[/color] to all targets."],
	"Arrow Rain": [15, false, true, "Deals [color=red]VALUE Damage[/color] to 3 random enemy targets."],
	"Eternal Pyre's Embrace": [15, false, true, "Deals [color=red]VALUE Damage[/color] to all enemies, [color=orange]Burning[/color] them for DURATION turns.", 3],
	"Icefall": [70, false, true, "Deals [color=red]VALUE Damage[/color] to all enemies, [color=blue]Frostbiting[/color] them for DURATION turns.", 3],
	"Gear Switch": [0, true, false, "Hannes: Enter Phase 2"],
	"Rend": [20, false, true, "Deals [color=red]VALUE Damage[/color] to 3 random enemy targets."],
	"Moonbeam": [100, false, true, "Deals [color=red]VALUE Damage[/color] to all targets."],
}

#Use these skills ID, but fetch skill module path from dictionary in Methods
var bt_reference := ["Health", "Basic Attack", "Speed"]
@export var bt_slime := [150, 20, 50]
@export var bt_slime_skills := ["Devour", "Goop", "Eternal Pyre's Embrace", ""]
@export var bt_rat := [100, 30, 70]
@export var bt_rat_skills := ["Toxic Bite", "Dap Up", "", ""]
@export var bt_angel := [130, 20, 40]
@export var bt_angel_skills := ["Judgment", "Cure", "Bless", ""]

@export var bt_knight_low := [90, 30, 30]
@export var bt_elf_low := [60, 40, 60]
@export var bt_wizard_low := [50, 50, 20]

@export var bt_shadow_wizard_a := [200, 30, 55]
@export var bt_shadow_wizard_b := [200, 30, 55]

@export var bt_knight_high := [110, 30, 40]
@export var bt_elf_high := [70, 40, 80]
@export var bt_wizard_high := [70, 50, 30]


@export var bt_hannes := [1000, 30, 50]

extends Node

#General tracker variables, used during gameplay, but are not needed to save.
var destination_area_id : String
var destination_resource : String
var move_direction : String
var transitioning := false
var battle_type := 2
#0 : Random low level battle
#1 : Random high level battle
#2 : Tutorial battle
#3 : Shadow wizards - Boss
#4 : Hannes - Final boss
var cutscene_playing := false
var dialogue_active = false

#Overworld data
var size := 1
var current_area_id := "sewers"
var current_resource := "res://main/overworld/areas/sewers.tscn"
var random_battle_type := 0
var base_escape_chance := 50
var effective_escape_chance
var repellant_active := false

#Story flags
var cutscene_1 = false
var rat_talk_1 := false
var just_size_2 := false
var rat_talk_2 := false
var golem_talk_1 := false
var golem_talk_2 := false
var gob_rejection := false
var gob_assess := false
var gob_sells_grimoire := false

#Items & money data
var cured_ham := 1
var flesh := 1
var goats_blood := 1
var money := 1
var repellant_owned := false

#Battle stats data
var bt_party := ["slime", "rat"]

var bt_reference := ["health", "basic attack dmg", "speed"]

#Storing these here rather than in the node because values might be modified throughout the game
var skills_data = {
	"Reference" : ["+Value", "Single Target?", "Enemy?", "Description", "Duration (optional)"],
	"Devour" : [20, true, true, "Deals [color=red]VALUE Damage[/color] to an enemy, and [color=cyan]devours[/color] the enemy if they have [color=orange]20% health or less[/color], giving a bonus turn immediately."],
	"Toxic Bite": [20, true, true, "Deals [color=red]VALUE Damage[/color] to an enemy, [color=green]Poisoning[/color] them for DURATION turns.", 3],
	"Goop": [0, true, true, "Apply [color=cyan]Goop[/color] to an enemy, slowing their speed by 30% for DURATION turns.", 5],
	"Dap Up": [0, true, false, "Add [color=#1f93ff]action value[/color] equal to half your speed to an ally."]
}

#Use these skills ID, but fetch skill module path from dictionary in Methods
var bt_slime := [150, 30, 50]
var bt_slime_skills := ["Devour", "Goop", "", ""]
var bt_rat := [75, 40, 70]
var bt_rat_skills := ["Toxic Bite", "Dap Up", "", ""]
var bt_angel := [120, 20, 40]
var bt_angel_skills := ["Judgment", "Cure", "Haste", ""]

var bt_knight_low := [100, 30, 30]
var bt_elf_low := [70, 40, 60]

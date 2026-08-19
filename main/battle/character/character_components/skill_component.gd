class_name SkillComponent extends Node

@onready var parent: BattleCharacter = $"../"

@export var skill_1: String
@export var skill_2: String
@export var skill_3: String
@export var skill_4: String
@export var skill_5: String #For extra complex characters

var skills: Array[Skill] = []

func _ready():
	if parent.ally:
		var path = "bt_" + parent.battle_id + "_skills"
		var skills_array = Global.sav.get(path)
		skill_1 = skills_array[0]
		skill_2 = skills_array[1]
		skill_3 = skills_array[2]
		skill_4 = skills_array[3]
	
	if not Methods.current_scene is BattleScene:
		printerr("SkillComponent: Not in battle scene")
		return
	skills.append(Methods.current_scene.skills.load_skill_node(skill_1))
	skills.append(Methods.current_scene.skills.load_skill_node(skill_2))
	skills.append(Methods.current_scene.skills.load_skill_node(skill_3))
	skills.append(Methods.current_scene.skills.load_skill_node(skill_4))
	skills.append(Methods.current_scene.skills.load_skill_node(skill_5))
	skills = skills.filter(func(value): return value != null)
	

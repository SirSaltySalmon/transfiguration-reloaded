class_name SkillNodeConnector extends Control

@export var main: BattleScene

func update_skill_options():
	var id = main.current_char.battle_id
	var path = "bt_" + id + "_skills"
	var skills_array = Global.get(path)
	
	for skill in get_children():
		if skill is not SkillButton:
			printerr("SkillNodeConnector: Button is not appropriate")
			return
		
		skill.node = null
		var skill_name: String = skills_array[skill.index]
		if skill_name.is_empty():
			skill.text = "-Empty-"
			return
		skill.text = skill_name
		skill.node = main.skills.get_skill(skill_name)

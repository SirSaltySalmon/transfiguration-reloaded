class_name SkillCenter extends Node3D

@export var main: BattleScene

var loaded_skills: Array = []

func load_skill_node(skill_id: String):
	if skill_id.is_empty():
		return
	for skill_packed in loaded_skills:
		if skill_packed[0] == skill_id:
			return #Skill is already loaded
	var path = Methods.skills_path_dict[skill_id]
	var new_skill = load(path).instantiate()
	add_child(new_skill)
	loaded_skills.append([skill_id, new_skill])

func get_skill(skill_id: String) -> Skill: #Skill must be loaded
	for skill_packed in loaded_skills:
		if skill_packed[0] == skill_id:
			return skill_packed[1]
	return null

func focus_on_target(target, text := ""):
	if text != "":
		main.ui.display_move(text)
	await main.cam.tween_cam_to(target)
	return

func use_skill(skill_id: String, user: BattleCharacter, target):
	var skill = get_skill(skill_id)
	if skill == null:
		return
	
	skill.use(user, target)
	## effects positioning is handled in the skill class
	## will have functions for tp to targe
	## more advanced will be in the individual skill instance
	## eg cashnado is only one single spot, moonbeam is a scary giant beam

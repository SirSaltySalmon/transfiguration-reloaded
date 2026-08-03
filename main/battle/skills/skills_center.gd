class_name SkillCenter extends Node3D

@export var main: BattleScene
@export var cine_anim: AnimationPlayer

var loaded_skills: Array = []

func load_skill_node(skill_id: String):
	if skill_id.is_empty():
		return
	for skill_packed in loaded_skills:
		if skill_packed[0] == skill_id:
			return skill_packed[1]
	var path = Methods.skills_path_dict[skill_id]
	var skill_node = load(path).instantiate()
	add_child(skill_node)
	loaded_skills.append([skill_id, skill_node])
	return skill_node

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

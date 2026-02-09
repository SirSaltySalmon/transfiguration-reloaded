class_name SkillButton extends BattleButton

@export var main: BattleScene
@export var skill_desc: SkillDescriptionHandler
@export var index: int

var node: Skill

func _on_mouse_entered():
	super()
	if node == null:
		return
	skill_desc.show_desc(node.description)

func _on_pressed():
	if node == null:
		return
	var target = await main.target.select_target(node.get_target_choices(true), node.is_single_target)
	if target == null:
		return
	node.use(main.current_char, target)

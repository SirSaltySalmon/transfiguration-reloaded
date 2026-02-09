class_name Skill extends Node3D

@export var id: String
@export var effect_base: Node3D

var effect_instances = []
## each instance is 2D, containing [effect node, battle char]

var value: int
var is_single_target: bool
var is_enemy_target: bool
var description: String
var duration: int

var main: BattleScene = Methods.current_scene
var center = main.skills

func _ready():
	effect_base.hide()
	var data = Global.skills_data[id]
	value = data[0]
	is_single_target = data[1]
	is_enemy_target = data[2]
	description = data[3]
	if data.size() >= 5:
		duration = data[4]
	substitute_desc_values()

func substitute_desc_values():
	description = description.replace("VALUE", str(value))
	if not duration: return
	description = description.replace("DURATION", str(duration))

func get_target_choices(is_ally: bool):
	if (is_ally and is_enemy_target) or (not is_ally and not is_enemy_target):
		return main.get_alive_enemies()
	else:
		return main.get_alive_allies()
	

func set_effect(target: BattleCharacter):
	var effect = effect_base.duplicate()
	add_child(effect)
	effect_instances.append([effect, target])
	effect.global_position = target.global_position
	effect.global_position.y += 0.2
	effect.show()
	return effect

func kill_effect_for(target: BattleCharacter):
	for effect in effect_instances:
		if effect[1] == target:
			effect[0].queue_free()
			effect_instances.erase(effect)
			return

func kill_effects():
	for effect in effect_instances:
		effect[0].queue_free()
	effect_instances.clear()

func use(user: BattleCharacter, target):
	## target can be an array or a battlechar
	
	## await user.start_action("skill name")
	
	## await center.focus_on_target(target, "additional text")
	## var effect = set_effect(target)
	## skill code
	## effect code
	## await Methods.wait(1.0)
	
	## kill_effects()
	## Broadcaster.action_over.emit()
	pass

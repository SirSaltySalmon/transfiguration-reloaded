class_name ItemsButton extends BattleButton

@export var item_sprite: Sprite2D
@export var item_desc_display: RichTextLabel

@export var item_name: String
@export var item_id: String
@export var sprite_id: int
@export var item_desc: String

@export var effect_base: Node3D
var effect_instances = []

@export var main: BattleScene

var count = 0

func _physics_process(delta: float) -> void:
	count = Global.sav.get(item_id)
	if count > 0:
		#eg Cured Ham x20
		text = item_name + " x" + str(count)
	else:
		text = "- Empty -"

func _on_mouse_entered():
	super()
	if count <= 0:
		return
	item_sprite.frame = sprite_id
	item_desc_display.text = item_desc

func set_effect(target: BattleCharacter):
	var effect = effect_base.duplicate()
	add_child(effect)
	effect_instances.append([effect, target])
	effect.global_position = target.global_position
	effect.global_position.y += 0.2
	effect.show()
	return effect

func kill_effects():
	for effect in effect_instances:
		effect[0].queue_free()
	effect_instances.clear()

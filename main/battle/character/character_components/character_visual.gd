class_name CharacterVisual extends Node3D

@export var shaker: ShakerComponent3D
@export var turn_indicator: Sprite3D
@export var anim: AnimationPlayer

const vec3big = Vector3(1.0, 1.0, 1.0)
const vec3small = Vector3(0.4, 0.4, 0.4)

var tween

func _ready() -> void:
	hide_indicator()

func shake():
	shaker.play_shake()

func indicate(is_green: bool):
	turn_indicator.show()
	var color
	if is_green:
		color = Color(Color.GREEN)
	else:
		color = Color(Color.YELLOW)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(turn_indicator, "scale", vec3small, 0.5 / Methods.anim_speed).from(vec3big)
	tween.tween_property(turn_indicator, "modulate", Color(color, 0.4), 0.5 / Methods.anim_speed).from(color)

func hide_indicator():
	turn_indicator.hide()

func death_anim():
	anim.play("death_anim")

func revive_anim():
	anim.play("revive_anim")

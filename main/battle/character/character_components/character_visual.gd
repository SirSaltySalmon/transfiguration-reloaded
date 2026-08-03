class_name CharacterVisual extends Node3D

@export var shaker: ShakerComponent3D
@export var turn_indicator: Sprite3D
@export var anim: AnimationPlayer
@export var indicator_anim: AnimationPlayer

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
	turn_indicator.modulate = color
	indicator_anim.stop()
	indicator_anim.play("indicate")
	

func hide_indicator():
	indicator_anim.stop()
	turn_indicator.hide()

func death_anim():
	anim.play("death_anim")

func revive_anim():
	anim.play("revive_anim")

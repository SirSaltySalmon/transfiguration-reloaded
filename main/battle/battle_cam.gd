class_name BattleCam extends Camera3D

@export var main: BattleScene

@onready var handheld_shake = $HandheldShake
#use play_shake() and stop_shake()
@onready var impact_shake = $ImpactShake

const small_shake_intensity = 1
const small_shake_duration = 0.5

const big_shake_intensity = 2
const big_shake_duration = 1.5

var idle_position = Vector3(4.2, 18, 0)
var tween

func _ready():
	position = idle_position

func get_destination_position(target) -> Vector3:
	var destination: Vector3
	if target is Array[BattleCharacter]:
		destination = Vector3(-5, 12, 0)
		if target[0].ally:
			destination.x = 10.0
	else:
		destination = target.global_position
		destination.y = 10
		destination.x += 2
	return destination

func tween_cam_to(target):
	main.ui.vignette.focus()
	var destination = get_destination_position(target)
	return await tween_cam(destination)

func return_to_idle():
	main.ui.vignette.unfocus()
	return await tween_cam(idle_position)

func tween_cam(destination):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "position", destination, 0.3 / Methods.anim_speed)
	await tween.finished
	return

func teleport_cam_to(target):
	position = get_destination_position(target)

func shake():
	impact_shake.intensity = small_shake_intensity
	impact_shake.duration = small_shake_duration
	impact_shake.play_shake()

func big_shake():
	impact_shake.intensity = big_shake_intensity
	impact_shake.duration = big_shake_duration
	impact_shake.play_shake()

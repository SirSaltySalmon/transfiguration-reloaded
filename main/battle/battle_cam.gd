class_name BattleCam extends Node3D

@export var main: BattleScene

@export var handheld_shake: ShakerComponent3D
#use play_shake() and stop_shake()
@export var impact_shake: ShakerComponent3D
@export var big_impact_shake: ShakerComponent3D

var idle_position := Vector3(4.2, 18, 0)
var idle_rot := Vector3(-80, 90, 0)
var tween

func _ready():
	position = idle_position
	rotation_degrees = idle_rot

func get_destination_position(target) -> Vector3:
	var destination: Vector3
	if target is Array[BattleCharacter]:
		destination = Vector3(-4, 12, 0)
		if target[0].ally:
			destination.x = 10.0
	else:
		destination = target.global_position
		destination.y = 10
		destination.x += 2
	return destination

func tween_cam_to(target):
	main.ui.vignette.focus()
	rotation_degrees = idle_rot
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
	if Global.sav.disable_screen_shake:
		return
	impact_shake.force_stop_shake()
	impact_shake.play_shake()

func big_shake():
	if Global.sav.disable_screen_shake:
		return
	big_impact_shake.force_stop_shake()
	big_impact_shake.play_shake()

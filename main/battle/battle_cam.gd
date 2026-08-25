class_name BattleCam extends Node3D

@export var main: BattleScene

@export var handheld_shake: ShakerComponent3D
#use play_shake() and stop_shake()
@export var impact_shake: ShakerComponent3D
@export var big_impact_shake: ShakerComponent3D
@export var cam: Camera3D

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
	rotation_degrees = idle_rot
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

func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = cam.project_ray_origin(mouse_pos)
	var to = from + cam.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	
	# Create ray query and set the parameters
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	
	# Set the collision mask (change based on your layer setup)
	ray_query.collision_mask = 2  # Set the mask to the layer you want to collide with
	
	# Perform raycast
	var raycast_results = space.intersect_ray(ray_query)
	
	return raycast_results

func _input(event: InputEvent) -> void:
	if event.is_action("left_click"):
		if main.target.is_selecting_one:
			if main.current_char:
				if main.current_char.ally:
					target_selection_mouse_input()

func target_selection_mouse_input():
	var raycast = shoot_ray() 
	
	if raycast.is_empty():
		return
	
	var collider = raycast["collider"]
	if not is_instance_valid(collider):
		return
	if not collider is BattleCharacter:
		return
	if collider.health.dead:
		return
	
	main.target._handle_mouse_target_input(collider)

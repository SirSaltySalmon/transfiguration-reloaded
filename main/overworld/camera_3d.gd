extends Camera3D

@export var MAX_DISTANCE = 2
@export var MAX_SCROLLING_SPEED = 0.1
@export var ACCEL = 0.005

var scrolling_speed = 0.0

var looking_left = false
var looking_right = false

var previous_collider = self
var current_collider = self

### Transitioning between areas is stored in Main node to simplify logic and variables connecting ###

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	highlight_interactables()
	if not Global.transitioning:
		handle_camera()

func handle_camera():
	# Move the camera based on the scrolling speed
	position.x += scrolling_speed
	
	# If looking left and within the max left distance
	if looking_left and position.x > -MAX_DISTANCE:
		if scrolling_speed > -MAX_SCROLLING_SPEED:
			scrolling_speed -= ACCEL
		else:
			scrolling_speed = -MAX_SCROLLING_SPEED
	
	# If looking right and within the max right distance
	elif looking_right and position.x < MAX_DISTANCE:
		if scrolling_speed < MAX_SCROLLING_SPEED:
			scrolling_speed += ACCEL
		else:
			scrolling_speed = MAX_SCROLLING_SPEED
	
	# Slow down scrolling when no direction is being pressed
	if (
		(not looking_right and not looking_left) or
		(position.x > MAX_DISTANCE && looking_right) or
		(position.x < -MAX_DISTANCE && looking_left)
		):
		if scrolling_speed > 0:
			scrolling_speed -= ACCEL
			if scrolling_speed < 0:
				scrolling_speed = 0
		elif scrolling_speed < 0:
			scrolling_speed += ACCEL
			if scrolling_speed > 0:
				scrolling_speed = 0
		else:
			if looking_right:
				looking_right = false
			elif looking_left:
				looking_left = false

func _input(event):
	if event.is_action_pressed("left_click"):
		if current_collider.has_method("interact") and can_interact():
			current_collider.interact()
		pass

func can_interact():
	return !Global.transitioning

func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	
	# Create ray query and set the parameters
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	
	# Set the collision mask (change based on your layer setup)
	ray_query.collision_mask = 1  # Set the mask to the layer you want to collide with
	
	# Perform raycast
	var raycast_results = space.intersect_ray(ray_query)
	
	return raycast_results

func highlight_interactables():
	if Global.dialogue_active or Global.transitioning:
		if previous_collider.has_method("unhighlight"):
			previous_collider.unhighlight()
			previous_collider = self
		current_collider = self
		return
	
	var raycast = shoot_ray()
	if !raycast.is_empty():
		current_collider = raycast["collider"]
		previous_collider = current_collider
		if current_collider.has_method("highlight"):
			current_collider.highlight()
	else:
		if previous_collider.has_method("unhighlight"):
			previous_collider.unhighlight()
			previous_collider = self
		current_collider = self

func _on_left_mouse_entered() -> void:
	looking_left = true

func _on_left_mouse_exited() -> void:
	looking_left = false

func _on_right_mouse_entered() -> void:
	looking_right = true

func _on_right_mouse_exited() -> void:
	looking_right = false

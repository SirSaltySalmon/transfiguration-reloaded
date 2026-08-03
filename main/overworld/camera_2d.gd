extends Camera2D

@export var main: Node2D

@export var MAX_SCROLLING_SPEED = 200.0
@export var ACCEL = 100.0

var scrolling_speed = 0.0

var looking_left = false
var looking_right = false

var previous_collider = self
var current_collider = self

var base_x = 640.0
var BOUND_LEFT := 0.0
var BOUND_RIGHT := 0.0

func _ready():
	base_x = position.x
	BOUND_LEFT = base_x - 112
	BOUND_RIGHT = base_x + 241

func _physics_process(delta: float) -> void:
	if main.entered:
		handle_camera(delta)

func handle_camera(delta: float) -> void:
	var direction := float(int(looking_right) - int(looking_left))
	var target_speed = direction * MAX_SCROLLING_SPEED

	scrolling_speed = move_toward(
		scrolling_speed,
		target_speed,
		ACCEL * delta
	)

	position.x += scrolling_speed
	position.x = clampf(position.x, BOUND_LEFT, BOUND_RIGHT)

	# Stop velocity when pushing against a boundary.
	if (
		(position.x <= BOUND_LEFT and scrolling_speed < 0.0)
		or (position.x >= BOUND_RIGHT and scrolling_speed > 0.0)
	):
		scrolling_speed = 0.0

func _on_left_mouse_entered() -> void:
	looking_left = true

func _on_left_mouse_exited() -> void:
	looking_left = false

func _on_right_mouse_entered() -> void:
	looking_right = true

func _on_right_mouse_exited() -> void:
	looking_right = false

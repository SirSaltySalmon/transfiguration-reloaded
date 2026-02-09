class_name TurnComponent extends Sprite3D

@export var bar: ProgressBar
@export var speed_label: Label

@onready var parent: BattleCharacter = $"../"

@onready var waiting_stylebox: StyleBox = preload("res://assets/battle/ui/turnbar_waiting.tres")
@onready var ready_stylebox: StyleBox = preload("res://assets/battle/ui/turnbar_ready.tres")

var speed_increment: float

var main: Node3D

func init_component():
	Broadcaster.connect("action_over", _on_action_over)
	bar.max_value = 50
	bar.value = 0
	main = Methods.current_scene
	update_speed()

func increment():
	bar.value += speed_increment
	if bar.value >= bar.max_value:
		ready_to_move()

func ready_to_move():
	bar.add_theme_stylebox_override("fill", ready_stylebox)
	Broadcaster.ready_to_move.emit(parent)

func _on_action_over():
	if main.current_char != parent:
		return
	bar.value = 0
	bar.add_theme_stylebox_override("fill", waiting_stylebox)

func force_action():
	await Broadcaster.action_over
	bar.value = bar.max_value
	ready_to_move()

func update_speed():
	var current_speed = int(parent.speed * parent.speed_mult)
	speed_label.text = "SPD " + str(current_speed)
	speed_increment = (current_speed) / 50.0

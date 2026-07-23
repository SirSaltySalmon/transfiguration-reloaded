extends Button

@onready var dating: DatingSim = $"../../../.."
@onready var timer: Timer = $Timer

func _ready():
	Methods.connect("dating_require_response", toggle_off)

func toggle_off():
	button_pressed = false
	timer.stop()

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		dating.balloon.force_input()
		timer.start(0.2)
	else:
		timer.stop()

func _on_timer_timeout() -> void:
	dating.balloon.force_input()

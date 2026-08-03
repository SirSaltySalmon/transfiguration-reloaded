extends CheckButton

@onready var dating: DatingSim = $"../../../.."
@onready var timer: Timer = $Timer

func _ready():
	Methods.connect("dating_require_response", toggle_off)
	disabled = true

func enable():
	disabled = false

func disable():
	disabled = true

func toggle_off():
	button_pressed = false
	timer.stop()

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if not is_instance_valid(dating.balloon):
			toggle_off()
			return
		dating.balloon.force_input()
		if not dating.balloon.is_waiting_for_input:
			await dating.balloon.dialogue_label.finished_typing
		if button_pressed: # check if still toggled
			timer.start(2.0)
		else:
			timer.stop()
	else:
		timer.stop()

func _on_timer_timeout() -> void:
	if not button_pressed:
		return
	if not is_instance_valid(dating.balloon):
		toggle_off()
	dating.balloon.force_input()
	if not dating.balloon.is_waiting_for_input:
		await dating.balloon.dialogue_label.finished_typing
	timer.start(2.0)

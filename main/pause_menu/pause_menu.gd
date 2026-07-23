extends CanvasLayer

var paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	paused = not paused
	get_tree().paused = paused
	if paused:
		show()
	else:
		hide()

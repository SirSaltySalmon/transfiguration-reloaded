extends Button

@onready var pause_menu: PauseMenu = $"../../../../PauseMenu"

func _on_pressed() -> void:
	pause_menu.toggle_pause()

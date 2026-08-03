extends CheckButton

func _ready():
	button_pressed = Global.sav.disable_screen_shake

func _on_toggled(toggled_on: bool) -> void:
	Global.sav.disable_screen_shake = toggled_on

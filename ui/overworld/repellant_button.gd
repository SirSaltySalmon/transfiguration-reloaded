extends Button

func _ready():
	if Global.sav.repellant_owned:
		update_text()
		show()
	else:
		hide()

func _on_pressed() -> void:
	Global.sav.repellant_active = not Global.sav.repellant_active
	update_text()

func update_text():
	if Global.sav.repellant_active:
		text = "Repellant: ON"
	else:
		text = "Repellant: OFF"

extends ItemsButton

@onready var escape_button: Button = $"../../Escape/Yes"

func _on_pressed():
	if count <= 0:
		return
	if not Global.battle_type in [0, 1]:
		main.ui.display_move("Can't escape from an important fight!")
		return
	if main.current_char.health.has_effect("Frostbite"):
		main.ui.display_move("Frostbitten! Can't use items!")
		return
	
	main.ui.close()
	await main.current_char.start_action("Throw Money")
	
	escape_button.escape(true)

extends ItemsButton

@onready var escape_button: Button = $"../../Escape/Yes"

func _on_pressed():
	if count <= 0:
		return
	
	main.ui.close()
	await main.current_char.start_action("Throw Money")
	
	escape_button.escape(true)

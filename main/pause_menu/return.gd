extends Button

@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog

func _on_pressed() -> void:
	confirmation_dialog.show()
	
func _on_confirmation_dialog_confirmed() -> void:
	get_tree().paused = false
	Methods.return_to_title()

extends BattleButton

@export var main_ui: BattleUI

func _on_pressed():
	main_ui.change_to("options")

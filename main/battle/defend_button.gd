extends Button

@export var main: BattleScene

func _on_pressed() -> void:
	var target = await main.target.select_one_target([main.current_char])
	if target == null:
		main.cancel_selection()
		return
	main.current_char.use_defend()

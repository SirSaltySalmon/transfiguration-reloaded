extends Button

@export var main: BattleScene

func _on_pressed() -> void:
	var target = await main.target.select_one_target(main.get_alive_enemies())
	if target == null:
		return
	main.current_char.use_basic_attack(target)

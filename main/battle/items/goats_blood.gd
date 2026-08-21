extends ItemsButton

const REVIVE = preload("uid://cx7332sad04y6")

func _on_pressed():
	if count <= 0:
		return
	if main.current_char.health.has_effect("Frostbite"):
		main.ui.display_move("Frostbitten! Can't use items!")
		return
	
	var target = await main.target.select_one_target(main.get_dead_allies())
	if target == null:
		return
	
	await main.current_char.start_action("Goat's Blood")
	
	await main.skills.focus_on_target(target)
	var effect = set_effect(target)
	target.health.revive()
	effect.play("bless")
	SoundManager.play_sound(REVIVE)
	
	await Methods.wait(1.0)
	
	kill_effects()
	Broadcaster.action_over.emit()

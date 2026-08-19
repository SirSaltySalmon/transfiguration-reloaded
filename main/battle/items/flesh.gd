extends ItemsButton

const CURE = preload("uid://dvkat5k7gitu5")

func _on_pressed():
	if count <= 0:
		return
	
	var target = await main.target.select_one_target(main.get_alive_allies())
	if target == null:
		return
	
	await main.current_char.start_action("Flesh")
	
	await main.skills.focus_on_target(target)
	var effect = set_effect(target)
	target.health.restore_health(100)
	effect.play("cure")
	SoundManager.play_sound(CURE)
	
	await Methods.wait(1.0)
	
	kill_effects()
	Broadcaster.action_over.emit()

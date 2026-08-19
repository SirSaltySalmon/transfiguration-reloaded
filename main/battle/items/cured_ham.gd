extends ItemsButton

const CURE = preload("uid://dvkat5k7gitu5")

func _on_pressed():
	if count <= 0:
		return
	
	var target = await main.target.select_all_targets(main.get_alive_allies())
	if target == []:
		return
	
	await main.current_char.start_action("Cured Ham")
	
	await main.skills.focus_on_target(target)
	for targ in target:
		var effect = set_effect(targ)
		targ.health.restore_health(50)
		effect.play("cure")
	SoundManager.play_sound(CURE)
	
	await Methods.wait(1.0)
	
	kill_effects()
	Broadcaster.action_over.emit()

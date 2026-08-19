extends Skill

func use(user: BattleCharacter, target):
	await user.start_action("Dap Up")
	
	await center.focus_on_target(target)
	var effect = set_effect(target)
	target.turn.bar.value += user.speed / 2.0
	effect.play()
	await Methods.wait(1.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

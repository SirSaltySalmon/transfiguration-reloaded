extends Skill

func use(user: BattleCharacter, target):
	await user.start_action("Devour")
	
	await center.focus_on_target(target)
	var effect = set_effect(target)
	target.health.devour(value)
	effect.play("devour")
	await Methods.wait(1.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

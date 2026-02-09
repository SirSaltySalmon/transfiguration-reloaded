extends Skill

func use(user: BattleCharacter, target):
	await user.start_action("Goop")
	
	await center.focus_on_target(target)
	var effect = set_effect(target)
	target.health.add_effect("Goop", duration)
	target.health.damage_anim(Color.AQUA)
	effect.play("goop")
	await Methods.wait(1.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

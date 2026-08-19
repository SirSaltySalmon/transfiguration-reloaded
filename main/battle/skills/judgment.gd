extends Skill

const EXPLOSION = preload("uid://dr46lk80j3wv3")

func use(user: BattleCharacter, target):
	await user.start_action("Judgment")
	
	await center.focus_on_target(target)
	
	for i in range(3):
		assert(target is Array)
		var targ = target.pick_random()
		var effect = set_effect(targ)
		targ.health.take_damage(value)
		effect.play()
		SoundManager.play_sound(EXPLOSION)
		
		await Methods.wait(0.5 / Methods.anim_speed)
		
		if targ.health.dead:
			target.erase(targ)
			if target == []:
				break
	
	await Methods.wait(0.5 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

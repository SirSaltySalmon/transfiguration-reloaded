extends Skill

const ARROW = preload("uid://c7oebuk86c7xc")

func use(user: BattleCharacter, target):
	await user.start_action("Arrow Rain")
	
	await center.focus_on_target(target)
	
	for i in range(3):
		assert(target is Array)
		var targ = target.pick_random()
		var effect = set_effect(targ)
		targ.health.take_damage(value, user)
		effect.play("arrow_rain")
		SoundManager.play_sound(ARROW)
		
		await Methods.wait(0.5 / Methods.anim_speed)
		
		if targ.health.dead:
			target.erase(targ)
			if target == []:
				break
	
	kill_effects()
	Broadcaster.action_over.emit()

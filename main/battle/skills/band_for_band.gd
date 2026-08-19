extends Skill

const CHA_CHING = preload("uid://bx7u4n8qshaql")

func use(user: BattleCharacter, target):
	await user.start_action("Band For Band")
	
	await center.focus_on_target(target)
	
	for i in range(3):
		assert(target is Array)
		var targ = target.pick_random()
		var effect = set_effect(targ)
		targ.health.take_damage(value, user)
		effect.play()
		SoundManager.play_sound(CHA_CHING)
		
		await Methods.wait(0.5 / Methods.anim_speed)
		
		if targ.health.dead:
			target.erase(targ)
			if target == []:
				break
	
	clear_effects_references()
	Broadcaster.action_over.emit()

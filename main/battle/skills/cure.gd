extends Skill

const CURE = preload("uid://dvkat5k7gitu5")

func use(user: BattleCharacter, target):
	await user.start_action("Cure")
	
	await center.focus_on_target(target)
	var effect = set_effect(target)
	target.health.restore_health(value)
	
	for status_effect in target.health.status_icons.get_children():
		if status_effect is StatusEffect:
			if status_effect.is_negative():
				status_effect.remove_effect()
	
	SoundManager.play_sound(CURE)
	effect.play("cure")
	await Methods.wait(1.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

extends Skill

const SWORD_UNSHEATHE = preload("uid://cxq0q1n43wvqh")

func use(user: BattleCharacter, target):
	await user.start_action("Cross Slash")
	
	await center.focus_on_target(target)
	for targ in target:
		var effect = set_effect(targ)
		targ.health.take_damage(value, user)
		effect.play("cross_slash")
	SoundManager.play_sound(SWORD_UNSHEATHE)
	main.cam.shake()
	await Methods.wait(1.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

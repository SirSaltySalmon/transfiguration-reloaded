extends Skill

const DELTARUNE_EXPLOSION = preload("uid://dr3qx4r8ebre5")

func use(user: BattleCharacter, target):
	var damage = user.health.bar.value
	user.health.execute()
	await user.start_action("Benevolence")
	
	await center.focus_on_target(target)
	for targ in target:
		var effect = set_effect(targ)
		targ.health.take_damage(damage, user)
		effect.play("benevolence")
	SoundManager.play_sound(DELTARUNE_EXPLOSION)
	main.cam.big_shake()
	await Methods.wait(2.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

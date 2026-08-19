extends Skill

const BLESS = preload("uid://bi8wlu51ec6gw")

func use(user: BattleCharacter, target):
	await user.start_action("Bless")
	
	await center.focus_on_target(target)
	for targ in target:
		var effect = set_effect(targ)
		targ.health.add_effect("Bless", duration)
		targ.health.damage_anim(Color.GOLD)
		effect.play("bless")
	SoundManager.play_sound(BLESS)
	
	await Methods.wait(1.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

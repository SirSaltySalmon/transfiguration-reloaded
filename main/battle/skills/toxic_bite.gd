extends Skill

const LARGE_IMPACT = preload("uid://cgv60uv5ol5oi")

func use(user: BattleCharacter, target):
	await user.start_action("Toxic Bite")
	
	await center.focus_on_target(target)
	var effect = set_effect(target)
	target.health.take_damage(value)
	target.health.add_effect("Poison", duration)
	target.health.damage_anim(Color.DARK_GREEN)
	main.ui.display_move("Applied Poison!")
	effect.play("toxic_bite")
	SoundManager.play_sound(LARGE_IMPACT)
	await Methods.wait(1.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

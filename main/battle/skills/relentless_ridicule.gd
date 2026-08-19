extends Skill

const BONG = preload("uid://dbj7p78hj5cti")

func use(user: BattleCharacter, target):
	await user.start_action("Relentless Ridicule")
	
	main.queue_dialogue("relentless_ridicule")
	Global.custom_talker = user.name
	await main.dialogue_check() # Called manually!!
	
	await center.focus_on_target(target)
	var effect = set_effect(target)
	target.health.take_damage(value)
	target.health.add_effect("Insecure", duration)
	target.health.damage_anim(Color.DARK_GREEN)
	main.ui.display_move("Insecure! Takes extra damage!")
	effect.play("ridicule")
	SoundManager.play_sound(BONG)
	await Methods.wait(1.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

extends Skill

const ICEFALL = preload("uid://6y13a1h2t011")
const ICEFALL_TURBULENCE = preload("uid://4kpscv7ntjx7")
const GROUND_EXPLOSION = preload("uid://lb2y70jrobu0")

func _ready():
	super()
	center.cine_anim.add_animation_library("icefall", ICEFALL)

func use(user: BattleCharacter, target):
	SoundManager.play_sound(user.SPELL_STARTUP)
	main.ui.display_move("Icefall")
	main.ui.flavor_text.hide()
	center.cine_anim.play("icefall/play", -1, Methods.anim_speed)
	await center.cine_anim.animation_finished
	center.cine_anim.play("icefall/finish", -1, Methods.anim_speed)
	await Methods.wait(0.5 / Methods.anim_speed)
	SoundManager.play_sound(ICEFALL_TURBULENCE, 5.5)
	await center.cine_anim.animation_finished
	
	await center.focus_on_target(target)
	main.ui.display_move("Applied Frostbite!")
	main.cam.big_shake()
	for targ in target:
		var effect = set_effect(targ)
		targ.health.add_effect("Frostbite", duration)
		effect.play("icefall")
		targ.health.take_damage(value, user)
	SoundManager.play_sound(GROUND_EXPLOSION)

	await Methods.wait(2.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

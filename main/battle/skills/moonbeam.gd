extends Skill

const MOONBEAM_SFX = preload("uid://blkgqtvg8a8dx")
const MOONBEAM = preload("uid://7itw84ah42o6")
const GROUND_EXPLOSION = preload("uid://lb2y70jrobu0")

func _ready():
	super()
	center.cine_anim.add_animation_library("moonbeam", MOONBEAM)

func use(user: BattleCharacter, target):
	SoundManager.play_sound(user.SPELL_STARTUP)
	main.ui.display_move("Moonbeam")
	main.ui.flavor_text.hide()
	center.cine_anim.play("moonbeam/play_1", -1, Methods.anim_speed)
	await center.cine_anim.animation_finished
	center.cine_anim.play("moonbeam/play_2", -1, Methods.anim_speed)
	await center.cine_anim.animation_finished
	center.cine_anim.play("moonbeam/play_3", -1, Methods.anim_speed)
	SoundManager.play_sound(MOONBEAM_SFX)
	await center.cine_anim.animation_finished
	
	await center.focus_on_target(target)
	main.cam.big_shake()
	for targ in target:
		var effect = set_effect(targ)
		targ.health.take_damage(value, user)
		effect.play("moonbeam")
	SoundManager.play_sound(GROUND_EXPLOSION)

	await Methods.wait(2.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

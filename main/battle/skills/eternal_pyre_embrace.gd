extends Skill

@export var fx_anim: AnimationPlayer

const GROUND_EXPLOSION = preload("uid://lb2y70jrobu0")
const EPE = preload("uid://blmxb3a3ydqbp")


func _ready():
	super()
	center.cine_anim.add_animation_library("epe", EPE)

func play():
	fx_anim.play("play")

func stop():
	fx_anim.play("RESET")

func use(user: BattleCharacter, target):
	SoundManager.play_sound(user.SPELL_STARTUP)
	main.ui.display_move("Eternal Pyre's Embrace")
	main.ui.flavor_text.hide()
	play()
	center.cine_anim.play("epe/epe", -1, Methods.anim_speed)
	
	await center.cine_anim.animation_finished
	stop()
	
	await center.focus_on_target(target)
	main.ui.display_move("Applied Burn!")
	for targ in target:
		var effect = set_effect(targ)
		targ.health.add_effect("Burn", duration)
		effect.play()
		targ.health.take_damage(value, user)
	SoundManager.play_sound(GROUND_EXPLOSION)
	main.cam.big_shake()

	await Methods.wait(2.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()
	

extends Skill

const MOONBEAM = preload("uid://7itw84ah42o6")

func _ready():
	super()
	center.cine_anim.add_animation_library("moonbeam", MOONBEAM)

func use(user: BattleCharacter, target):
	main.ui.display_move("Moonbeam")
	main.ui.flavor_text.hide()
	center.cine_anim.play("moonbeam/play_1", -1, Methods.anim_speed)
	await center.cine_anim.animation_finished
	center.cine_anim.play("moonbeam/play_2", -1, Methods.anim_speed)
	await center.cine_anim.animation_finished
	center.cine_anim.play("moonbeam/play_3", -1, Methods.anim_speed)
	await center.cine_anim.animation_finished
	
	await center.focus_on_target(target)
	main.cam.big_shake()
	for targ in target:
		var effect = set_effect(targ)
		targ.health.take_damage(value, user)
		effect.play("moonbeam")

	await Methods.wait(2.0 / Methods.anim_speed)
	
	kill_effects()
	Broadcaster.action_over.emit()

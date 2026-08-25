extends Character

const REVIVE = preload("uid://cx7332sad04y6")

func normal_init():
	if Global.sav.gob_sells_grimoire and not Global.sav.shadow_wizards_defeated:
		show()
		%OmniLight3D.hide()
	else:
		queue_free()

func interact():
	await glow()
	await dialogue("grimoire_summoning")
	Global.battle_type = 3
	Global.sav.bt_party.append("angel")
	Methods.enter_battle()

func glow():
	%OmniLight3D.show()
	%ImpactShake.play_shake()
	SoundManager.play_sound(REVIVE)
	await Methods.wait(1.0)
	return

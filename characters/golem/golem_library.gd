extends Character

func normal_init():
	if not Global.sav.size >= 4:
		show()
	else:
		queue_free()

func interact():
	if not Global.golem_talk_2:
		await dialogue("golem_talk")
		Global.golem_talk_2 = true
	elif not Global.sav.shadow_wizards_defeated:
		await dialogue("golem_remember")
	elif Global.sav.shadow_wizards_defeated:
		Global.sav.size = 4
		Methods.play_fx_overworld("devour")
		queue_free()
		return
		
	Methods.flags_changed.emit()

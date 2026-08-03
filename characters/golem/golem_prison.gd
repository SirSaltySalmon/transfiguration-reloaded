extends Character

func normal_init():
	if not Global.sav.tutorial_fight_complete:
		show()
	else:
		hide()

func interact():
	if not Global.sav.tutorial_fight_complete and not Global.sav.golem_talk_1:
		await dialogue("golem_talk")
		Global.sav.golem_talk_1 = true
	elif not Global.sav.tutorial_fight_complete:
		await dialogue("golem_forget")
		
	Methods.flags_changed.emit()

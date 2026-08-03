extends Character

func normal_init():
	if "angel" in Global.sav.bt_party:
		show()
	else:
		hide()

func interact():
	if Global.sav.size == 7:
		await dialogue("angel_size_7")
	
	elif not Global.sav.angel_talk_1:
		await dialogue("angel_talk_1")
		Global.sav.angel_talk_1 = true
	elif not Global.sav.angel_talk_2 and Global.sav.size >= 5:
		await dialogue("angel_talk_2")
		Global.sav.angel_talk_2 = true
	
	Methods.flags_changed.emit()

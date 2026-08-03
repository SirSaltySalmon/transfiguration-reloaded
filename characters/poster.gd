extends Character

func normal_init():
	if Global.sav.size >= 5:
		show()
	else:
		hide()

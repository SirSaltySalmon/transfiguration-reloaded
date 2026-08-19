extends Character

func normal_init():
	if Global.sav.size == 7:
		queue_free()
	else:
		show()

func interact():
	Methods.enter_date()

extends Character

func normal_init():
	if Global.sav.size >= 2:
		queue_free()

func interact():
	Global.sav.size = 2
	Methods.play_fx_overworld("devour")
	queue_free()
	

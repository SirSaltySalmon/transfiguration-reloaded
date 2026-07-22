extends Character

func interact():
	## eat
	Global.size += 1
	Global.just_size_2 = true
	Methods.play_fx_overworld("devour")
	queue_free()
	
	Methods.flags_changed.emit()
	

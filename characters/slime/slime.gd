extends Character

func normal_init():
	sprite.texture = Methods.get_slime_texture()
	var pscale = 0.1 + (Global.sav.size - 1) * 0.03
	sprite.scale = Vector3(pscale, pscale, pscale)
	if Global.sav.size == 7:
		hide()
	else:
		show()

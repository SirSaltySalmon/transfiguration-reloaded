extends Character

@export var title := "shadow_1"
@export var blood : Sprite2D


func normal_init():
	super()
	if Global.sav.get(title):
		if blood:
			blood.show()
		queue_free()
	else:
		if blood:
			blood.hide()

func interact():
	await dialogue(title)
	Global.sav.set(title, true)
	
	death()
	Methods.flags_changed.emit()

func death():
	Methods.play_fx_overworld("devour")
	if blood:
		blood.show()
	queue_free()
	if Global.sav.shadow_1 and Global.sav.shadow_2 and Global.sav.shadow_3:
		Global.sav.size = 5

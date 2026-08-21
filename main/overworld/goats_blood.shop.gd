extends ShopButton

func _on_pressed():
	super()
	Global.sav.money -= cost
	Global.sav.goats_blood += 1

func _on_mouse_entered():
	super()
	if requirement():
		hover_label.text += "\nOwned: %s" % str(Global.sav.goats_blood)

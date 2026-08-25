extends ShopButton

func _on_pressed():
	super()
	Global.sav.money -= cost
	Global.sav.cured_ham += 1
	_on_mouse_entered()

func _on_mouse_entered():
	super()
	if requirement():
		hover_label.text += "\nOwned: %s" % str(Global.sav.cured_ham)

extends ShopButton

func _on_pressed():
	Global.sav.money -= cost
	Global.sav.goats_blood += 1

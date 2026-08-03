extends ShopButton

func _on_pressed():
	Global.sav.money -= cost
	Global.sav.flesh += 1

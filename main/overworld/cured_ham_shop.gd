extends ShopButton

func _on_pressed():
	Global.sav.money -= cost
	Global.sav.cured_ham += 1

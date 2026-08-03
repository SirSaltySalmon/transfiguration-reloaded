extends ShopButton

func _on_pressed():
	Global.sav.money -= cost
	Global.sav.stock_dict[stock_id] -= 1
	Global.sav.repellant_owned = true

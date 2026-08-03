extends ShopButton

func _on_pressed():
	Global.sav.money -= cost
	Global.sav.stock_dict[stock_id] -= 1
	Global.sav.bt_slime[0] += 50
	Global.sav.bt_rat[0] += 50
	Global.sav.bt_angel[0] += 50

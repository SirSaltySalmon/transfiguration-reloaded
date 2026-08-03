extends ShopButton

func _on_pressed():
	Global.sav.money -= cost
	Global.sav.stock_dict[stock_id] -= 1
	Global.sav.bt_angel_skills[3] = "Benevolence"

func requirement():
	return true if Global.sav.shadow_wizards_defeated else false

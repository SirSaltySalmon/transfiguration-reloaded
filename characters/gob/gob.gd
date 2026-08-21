extends Character

func interact():
	if Global.sav.size <= 2 and not Global.sav.gob_rejection:
		await dialogue("gob_rejection")
		Global.sav.gob_rejection = true
	elif Global.sav.size >= 3 and not Global.sav.gob_assess:
		await dialogue("gob_assess")
		Global.sav.gob_assess = true
	elif Global.sav.size >= 3 and not Global.sav.gob_sells_grimoire:
		await dialogue("gob_sells_grimoire")
		#repeat until grimoire is sold so no check flag, when sold flag is activated in dialogue code
	elif Global.sav.gob_sells_grimoire:
		SceneLoader.load_scene("res://main/overworld/shop_actual.tscn")
		pass

extends Character

func interact():
	if Global.size <= 2 and not Global.gob_rejection:
		await dialogue("gob_rejection")
		Global.gob_rejection = true
	elif Global.size >= 3 and not Global.gob_assess:
		await dialogue("gob_assess")
		Global.gob_assess = true
	elif Global.size >= 3 and not Global.gob_sells_grimoire:
		await dialogue("gob_sells_grimoire")
		#repeat until grimoire is sold so no check flag, when sold flag is activated in dialogue code
	elif Global.gob_sells_grimoire:
		#open shop menu
		pass

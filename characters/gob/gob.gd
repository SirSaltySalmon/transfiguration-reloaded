extends Character

func interact():
	var title : String
	if Global.size <= 2 and not Global.gob_rejection:
		title = "gob_rejection"
		Global.gob_rejection = true
	elif Global.size >= 3 and not Global.gob_assess:
		title = "gob_assess"
		Global.gob_assess = true
	elif Global.size >= 3 and not Global.gob_sells_grimoire:
		title = "gob_sells_grimoire"
		#repeat until grimoire is sold so no check flag
	elif Global.gob_sells_grimoire:
		#open shop menu
		pass
	
	if title:
		DialogueManager.show_dialogue_balloon(dialogue, title)

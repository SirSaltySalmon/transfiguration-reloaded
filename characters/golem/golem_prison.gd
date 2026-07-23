extends Character

func interact():
	var title : String
	if Global.sav.size <= 3 and not Global.sav.golem_talk_1:
		title = "golem_talk"
		Global.sav.golem_talk_1 = true
	elif Global.size <= 3:
		title = "golem_forget"
	
	if title:
		DialogueManager.show_dialogue_balloon(dialogue, title)
		
	Methods.flags_changed.emit()

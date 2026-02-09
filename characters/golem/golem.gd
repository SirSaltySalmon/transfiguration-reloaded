extends Character

func interact():
	var title : String
	if Global.size <= 3 and not Global.golem_talk_1:
		title = "golem_talk"
		Global.golem_talk_1 = true
	elif Global.size <= 3:
		title = "golem_forget"
	elif Global.size >= 4 and not Global.golem_talk_2:
		title = "golem_talk"
		Global.golem_talk_2 = true
	elif Global.size >= 4:
		title = "golem_remember"
	elif Global.size >= 5:
		## Eats golem
		pass
	
	if title:
		DialogueManager.show_dialogue_balloon(dialogue, title)

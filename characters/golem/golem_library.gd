extends Character

func interact():
	var title : String
	if not Global.golem_talk_2:
		title = "golem_talk"
		Global.golem_talk_2 = true
	elif not Global.sav.shadow_wizards_defeated:
		title = "golem_remember"
	elif Global.sav.shadow_wizards_defeated:
		Global.sav.size = 5
		Methods.play_fx_overworld("devour")
		queue_free()
		return
	
	if title:
		DialogueManager.show_dialogue_balloon(dialogue, title)
		
	Methods.flags_changed.emit()

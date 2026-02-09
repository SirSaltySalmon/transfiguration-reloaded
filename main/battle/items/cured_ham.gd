extends ItemsButton

func _on_pressed():
	var target = await main.target.select_all_targets(main.get_alive_allies())
	if target == null:
		return
	
	await main.current_char.start_action("Cured Ham")
	
	await main.skills.focus_on_target(target, "additional text")
	## set_effect(target)
	## skill code
	## effect code
	await Methods.wait(1.0)
	
	## effect.hide()
	Broadcaster.action_over.emit()

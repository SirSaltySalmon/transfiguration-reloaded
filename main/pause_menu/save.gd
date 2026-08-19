extends Button

func _physics_process(delta: float) -> void:
	if Methods.current_scene:
		if is_instance_valid(Methods.current_scene):
			if Methods.current_scene is OverworldMain:
				if Global.transitioning:
					disabled = true
					return
				elif Methods.current_scene.active_cutscene_name != "":
					disabled = true
					return
				disabled = false
				return
	disabled = true

func _on_pressed() -> void:
	Global.save()

extends Button

func _on_pressed() -> void:
	Global.reset()
	SceneLoader.load_scene("res://main/overworld/overworld_3d_main.tscn")

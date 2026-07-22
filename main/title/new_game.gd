extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_pressed() -> void:
	SceneLoader.load_scene("res://main/overworld/overworld_3d_main.tscn")

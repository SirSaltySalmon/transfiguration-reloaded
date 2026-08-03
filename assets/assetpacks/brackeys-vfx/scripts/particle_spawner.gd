extends Node2D

@export var vfx_scene: PackedScene

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		var vfx = vfx_scene.instantiate()
		vfx.position = get_global_mouse_position()
		add_child(vfx)

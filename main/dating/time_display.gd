extends Label

func _physics_process(delta: float) -> void:
	text = Time.get_time_string_from_system()

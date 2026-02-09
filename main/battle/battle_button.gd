class_name BattleButton extends Button

@export var parent: BattlePanel

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("pressed", _on_pressed)

func _on_mouse_entered():
	parent.update_quill(global_position)
	#TODO: For skills, fetch description from players, for items, fetch from given message
	pass

func _on_pressed():
	pass

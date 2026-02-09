extends StaticBody3D

class_name Character

@onready var sprite = $Sprite
@onready var highlight_effect = $Sprite/SubViewport/Sprite2D/Highlight
@onready var brighten_effect = $Sprite/SubViewport/Sprite2D/Brighten

@export var dialogue : DialogueResource
@export var zoom : int = -2
@export var offset : int = 0

func highlight():
	if highlight_effect.visible == false:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		highlight_effect.show()
		brighten_effect.show()
	
func unhighlight():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	highlight_effect.hide()
	brighten_effect.hide()

func interact():
	pass

extends StaticBody3D

class_name Character

@export var interactible := true

@onready var sprite = $Sprite
@onready var highlight_effect = $Sprite/SubViewport/Sprite2D/Highlight if interactible else null
@onready var brighten_effect = $Sprite/SubViewport/Sprite2D/Brighten if interactible else null

@export var dialogue_res : DialogueResource
@export var zoom : int = -2
@export var offset : int = 0

func _ready():
	Methods.flags_changed.connect(normal_init)

func highlight():
	if highlight_effect.visible == false:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		highlight_effect.show()
		brighten_effect.show()
	
func unhighlight():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	highlight_effect.hide()
	brighten_effect.hide()

func normal_init():
	pass

func interact():
	pass

func trigger_dialogue(title):
	DialogueManager.show_dialogue_balloon(dialogue_res, title)

func dialogue(title):
	trigger_dialogue(title)
	await DialogueManager.dialogue_ended
	return

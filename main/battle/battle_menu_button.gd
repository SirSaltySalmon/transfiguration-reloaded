class_name BattleMenuButton extends Button

@export var main_ui: BattleUI
@export var id: String

func _ready():
	connect("pressed", _on_pressed)

func _on_pressed():
	main_ui.change_to(id)

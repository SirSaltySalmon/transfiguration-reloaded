class_name ShopButton
extends Button

const CHA_CHING = preload("uid://bx7u4n8qshaql")

func _ready():
	connect("pressed", _on_pressed)
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	if not requirement():
		description_label.text = "Not unlocked!"
		in_stock_label.text = "Try growing bigger"
		disabled = true

@export var cost := 0
@export var stock_id := ""
@export var description_label: RichTextLabel
@export var in_stock_label : RichTextLabel

@onready var hover: Panel = $"../../../../../HoverItemDescription"
@onready var hover_label: RichTextLabel = $"../../../../../HoverItemDescription/MarginContainer/RichTextLabel"
@export var description := ""

func _physics_process(delta: float) -> void:
	if cost > Global.sav.money:
		disabled = true
	else:
		disabled = false
	
	if stock_id != "":
		if Global.sav.stock_dict[stock_id] <= 0:
			disabled = true
			in_stock_label.text = "Out of Stock"

func _on_pressed():
	SoundManager.play_sound(CHA_CHING)

func requirement():
	return true

func _on_mouse_entered():
	if requirement():
		hover_label.text = description
		hover.show()

func _on_mouse_exited():
	hover.hide()

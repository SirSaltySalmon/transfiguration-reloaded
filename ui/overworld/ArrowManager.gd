extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_arrows()
	Methods.flags_changed.connect(normal_init)

func normal_init():
	hide_arrows()
	show_arrows()

func show_arrows():
	for child in get_children():
		child.initialize_arrow()

func hide_arrows():
	for child in get_children():
		child.hide()

class_name Area
extends Node3D

@onready var arrow_manager = $ArrowManager
@export var area_id: String

func _ready() -> void:
	arrow_manager.hide()

func normal_init_all():
	for child in get_children():
		if child.has_method("normal_init"):
			child.normal_init()

func show_arrows():
	arrow_manager.show()

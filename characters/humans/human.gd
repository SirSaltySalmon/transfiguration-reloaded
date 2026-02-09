extends Node3D

@onready var idle = $Idle

func _ready() -> void:
	idle.play("idle")

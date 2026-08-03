class_name Shop
extends Node2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer

var entered := false

func _ready():
	animation_player.play("enter")
	await animation_player.animation_finished
	entered = true

class_name Shop
extends Node2D

const SHOP_BELL = preload("uid://wp1yikiw2i58")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var entered := false

func _ready():
	animation_player.play("enter")
	SoundManager.play_sound(SHOP_BELL)
	await animation_player.animation_finished
	entered = true

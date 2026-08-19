extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const DAP_UP = preload("uid://06xpo3nxi51v")

func play():
	animation_player.play("dap_up")

func play_sound():
	SoundManager.play_sound(DAP_UP)

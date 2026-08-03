extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play():
	animation_player.play("dap_up")

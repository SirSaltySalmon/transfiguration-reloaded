extends Node3D

@onready var spot_light_3d: SpotLight3D = $SpotLight3D
@onready var end_credits: Control = $EndCredits

const SPOTLIGHT = preload("uid://ivr65xk0jxhm")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spot_light_3d.light_energy = 0.0
	await Methods.wait(3.0)
	spot_light_3d.light_energy = 5.0
	SoundManager.play_sound(SPOTLIGHT)
	await Methods.wait(2.0)
	end_credits.start_scroll()
	# play light turn on sfx

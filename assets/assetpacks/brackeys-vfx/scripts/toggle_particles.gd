extends Node2D

func _ready() -> void:
	var particles = $GPUParticles2D
	particles.emitting = true
	await get_tree().create_timer(1.0).timeout
	particles.emitting = false

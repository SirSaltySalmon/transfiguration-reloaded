extends Node

func _ready():
	var particles = $GPUParticles2D
	particles.restart()
	await particles.finished
	queue_free()
	

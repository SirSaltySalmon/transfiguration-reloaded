class_name TriggerParticles
extends Node3D

@export var anim: AnimationPlayer

func play():
	anim.play("play")
	await anim.animation_finished
	queue_free()

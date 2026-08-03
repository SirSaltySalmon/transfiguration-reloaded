class_name ActivateParticles
extends Node3D

@export var anim: AnimationPlayer

func play():
	anim.play("play")

func stop():
	anim.play("RESET")

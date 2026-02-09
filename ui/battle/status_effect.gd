extends Node
class_name StatusEffect

## Some code I'm really not proud of
## I started off trying to make a cool modular system but end up
## making it the same old way anyways
## Luckily Skills system managed to succeed it
## If I ever expand on this, try implementing the save & load system
## That I figured out with skills

var target : HealthComponent
var duration : int

func _on_added() -> void:
	if name == "Goop":
		target.parent.speed_mult -= 0.3
		target.parent.turn.update_speed()
	elif name == "Haste":
		target.parent.speed_mult += 0.3
		target.parent.turn.update_speed()
	get_icon().show()

func trigger():
	var triggered := false
	if name == "Poison":
		target.poison()
		triggered = true
	elif name == "Burn":
		target.burn()
		triggered = true
	duration -= 1
	if duration <= 0:
		remove_effect()
	return triggered

func remove_effect():
	if name == "Goop":
		target.parent.speed_mult += 0.3
		target.parent.turn.update_speed()
	elif name == "Haste":
		target.parent.speed_mult -= 0.3
		target.parent.turn.update_speed()
	get_icon().hide()
	target.status_effects.erase(self)
	queue_free()
	return

func get_icon() -> Panel:
	return target.status_icons.find_child(name, false)

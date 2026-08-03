extends Character

@onready var timer = $IdleActionTimer
@onready var jumpanim = $JumpPlayer
var flip_last_action : bool = false

func normal_init():
	show()
	idle()

func idle() -> void:
	timer.wait_time = randf_range(0.5, 3)
	action()
	timer.start()

func action():
	var rng = randi_range(1, 4)
	if rng != 1 or flip_last_action:
		jump_and_rotate()
		flip_last_action = false
	else:
		flip()
		flip_last_action = true
	
func jump_and_rotate():
	jumpanim.play("jump")
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "rotation_degrees:y", randi_range(-10, 10), 0.3)

func flip():
	jumpanim.play("jump")
	var current_rotation : int = sprite.rotation_degrees.y
	var tween = get_tree().create_tween()
	var flip_direction : int = 180 if randf() < 0.5 else -180
	tween.tween_property(sprite, "rotation_degrees:y", current_rotation + flip_direction, 0.3)

func interact():
	if Global.sav.size == 7:
		await dialogue("rat_size_7")
	
	elif Global.sav.size == 1 and not Global.sav.rat_talk_1:
		await dialogue("rat_talk_1")
		Global.sav.rat_talk_1 = true
	elif Global.sav.just_size_2 and not Global.sav.rat_talk_2:
		await dialogue("rat_talk_2")
		Global.sav.rat_talk_2 = true
	elif Global.sav.size <= 2 and Global.sav.tutorial_fight_complete:
		await dialogue("rat_suggests_roaming")
	elif Global.sav.gob_sells_grimoire and Global.sav.current_area_id != "library" and not Global.sav.rat_comments_on_grimoire:
		await dialogue("rat_comments_on_grimoire")
		Global.sav.rat_comments_on_grimoire = true
	elif Global.sav.size >= 5 and not Global.sav.rat_comments_on_posters: # If 7 hits the other check so it's okay
		await dialogue("rat_comments_on_posters")
		Global.sav.rat_comments_on_posters = true
	
	Methods.flags_changed.emit()

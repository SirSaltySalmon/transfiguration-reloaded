extends BattlePanel

@export var scroll: Sprite2D
@export var quill: Sprite2D

func update_quill(pos: Vector2):
	pos.y += 40
	pos.x += 210
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	if not quill.visible:
		quill.show()
		tween.tween_property(quill, "modulate", Color.WHITE, 0.3 / Methods.anim_speed).from(Color(Color.WHITE, 0))
	tween.tween_property(quill, "global_position", pos, 0.3 / Methods.anim_speed)
	
func hide_quill():
	quill.hide()

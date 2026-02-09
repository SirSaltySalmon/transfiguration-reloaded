class_name Vignette extends ColorRect

@export var unfocused_alpha := 0.8
@export var unfocused_inner_rad := 0.5
@export var unfocused_outer_rad := 1.3

@export var focused_alpha := 1.0
@export var focused_inner_rad := 0.2
@export var focused_outer_rad := 1.0

func focus(time := 0.3):
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "material:shader_parameter/alpha", focused_alpha, time / Methods.anim_speed).from(unfocused_alpha)
	tween.tween_property(self, "material:shader_parameter/inner_radius", focused_inner_rad, time / Methods.anim_speed).from(unfocused_inner_rad)
	tween.tween_property(self, "material:shader_parameter/outer_radius", focused_outer_rad, time / Methods.anim_speed).from(unfocused_outer_rad)

func unfocus(time := 0.3):
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "material:shader_parameter/alpha", unfocused_alpha, time / Methods.anim_speed).from(focused_alpha)
	tween.tween_property(self, "material:shader_parameter/inner_radius", unfocused_inner_rad, time / Methods.anim_speed).from(focused_inner_rad)
	tween.tween_property(self, "material:shader_parameter/outer_radius", unfocused_outer_rad, time / Methods.anim_speed).from(focused_outer_rad)

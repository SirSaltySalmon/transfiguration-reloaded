class_name HealthComponent extends Sprite3D

@onready var bar = $SubViewport/ProgressBar
@onready var value_display = $SubViewport/ProgressBar/ValueDisplay
@onready var change_display = $SubViewport/ChangeDisplay

@onready var status_icons = $SubViewport/StatusIcons

@onready var parent: BattleCharacter = $"../"

@onready var healthy_stylebox: StyleBox = preload("res://assets/battle/ui/healthbar_healthy.tres")
@onready var devourable_stylebox: StyleBox = preload("res://assets/battle/ui/healthbar_devourable.tres")

signal health_changed
signal effect_triggered

var devouring_threshold: float
var dead: bool = false
var tweening_change_display: bool = false
var change_display_value: int = 0

var status_effects: Array[StatusEffect]

const poison_damage: int = 20
const burn_damage: int = 10

var main: BattleScene = Methods.current_scene
var sprite: Sprite3D

var damage_anim_tween

func init_component():
	bar.max_value = parent.max_health
	bar.value = bar.max_value
	_on_health_changed()
	change_display.hide()
	devouring_threshold = 0.2 * bar.max_value
	sprite = parent.sprite
	connect("health_changed", _on_health_changed)

func get_health() -> int:
	return bar.value

func take_damage(value: int, attacker: BattleCharacter = parent, custom_color: Color = Color.RED) -> void:
	var final_value = -value
	if has_effect("Vulnerable"):
		final_value = int(final_value * 1.5)
	if attacker != parent && (attacker.health.has_effect("Burn") or has_effect("Defend")):
		final_value = int(final_value * 0.5)
	bar.value += final_value
	main.cam.shake() ## Because camera shake only when damage is taken, but damage anim can trigger without damage
	damage_anim(custom_color)
	tween_change_display(final_value)

func restore_health(value: int) -> void:
	bar.value += value
	tween_change_display(value)

func execute():
	bar.value = 0
	tween_change_display(-999)

func devour(damage: int):
	take_damage(damage)
	if bar.value <= devouring_threshold:
		execute()
		change_display.text = " -DEVOURED"
		main.devoured_count += 1
		main.ui.display_move("Devoured! Gained bonus action!")
		main.current_char.turn.force_action()

func add_effect(effect_name: String, duration: int):
	if has_effect(effect_name):
		var effect = get_effect_node(effect_name)
		if effect.duration > duration:
			return
		effect.duration = duration
		main.ui.display_move("Duration extended!")
		return
	var new_effect = StatusEffect.new()
	new_effect.name = effect_name
	new_effect.duration = duration
	new_effect.target = self
	status_effects.append(new_effect)
	new_effect._on_added()
	return

func get_effect_node(effect_name: String) -> StatusEffect:
	for effects in status_effects:
		if effects.name == effect_name:
			return effects
	return null

func has_effect(effect_name: String) -> bool:
	for effects in status_effects:
		if effects.name == effect_name:
			return true
	return false

func trigger_all_effects():
	for effect in status_effects:
		var is_triggered = effect.trigger()
		if is_triggered:
			await effect_triggered
		if dead:
			Broadcaster.action_over.emit()
			return true
	return false

func remove_all_effects():
	for effect in status_effects:
		await effect.remove_effect()
	return

func poison():
	await main.cam.tween_cam_to(parent)
	main.ui.display_move("Poison")
	take_damage(poison_damage, parent, Color.DARK_GREEN)
	await Methods.wait(1.0 / Methods.anim_speed)
	effect_triggered.emit()
	return

func burn():
	await main.cam.tween_cam_to(parent)
	main.ui.display_move("Burn")
	take_damage(burn_damage, parent, Color.ORANGE_RED)
	await Methods.wait(1.0 / Methods.anim_speed)
	effect_triggered.emit()
	return

func damage_anim(color: Color):
	parent.visual.shake()
	damage_anim_tween = get_tree().create_tween()
	damage_anim_tween.tween_property(sprite, "modulate", Color.WHITE, 1.0 / Methods.anim_speed).from(color)

func tween_change_display(value):
	health_changed.emit()
	change_display.show()
	change_display_value += value
	if change_display_value < 0:
		change_display.modulate = Color.DARK_RED
		change_display.text = " " + str(change_display_value) + " HP"
	else:
		change_display.modulate = Color.GREEN
		change_display.text = " +" + str(change_display_value) + " HP"
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(change_display, "scale", Vector2(1.3, 1.3), 0.3 / Methods.anim_speed).from(Vector2(1.0, 1.0))
	tween.tween_property(change_display, "scale", Vector2(1.0, 1.0), 0.3 / Methods.anim_speed)
	tween.tween_property(change_display, "modulate", Color(change_display.modulate, 0), 1 / Methods.anim_speed)
	await tween.finished
	change_display.hide()
	change_display_value = 0

func manage_stylebox_color():
	if (bar.value - Global.skills_data["Devour"][0]) <= devouring_threshold:
		bar.add_theme_stylebox_override("fill", devourable_stylebox)
	else:
		bar.add_theme_stylebox_override("fill", healthy_stylebox)

func _on_health_changed() -> void:
	if bar.value > 0:
		value_display.text = str(bar.value) + "/" + str(bar.max_value)
		manage_stylebox_color()
	elif not dead:
		death()
		value_display.text = "DEAD"

func death():
	dead = true
	remove_all_effects()
	if damage_anim_tween:
		damage_anim_tween.kill()
	parent.turn.bar.value = 0
	parent.visual.death_anim()
	## modifying in alive chars arrays have been refactored

func revive():
	bar.value = bar.max_value / 2
	dead = false
	tween_change_display(999)
	change_display.text = " +REVIVED"
	parent.visual.revive_anim()
	pass

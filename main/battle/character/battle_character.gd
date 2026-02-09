extends StaticBody3D
class_name BattleCharacter

@export var battle_id: String
@export var ally: bool

@onready var sprite = $CharacterVisual/Sprite
@onready var health: HealthComponent = $HealthComponent
@onready var turn: TurnComponent = $TurnComponent

@onready var visual: CharacterVisual = $CharacterVisual

var main: BattleScene = Methods.current_scene

var max_health: int
var basic_attack: int
var speed: int
var speed_mult := 1.0

var index_at_death := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stats = Global.get("bt_" + battle_id)
	max_health = stats[0]
	basic_attack = stats[1]
	speed = stats[2]
	
	for child in get_children():
		if child.has_method("init_component"):
			child.init_component()

func start_action(text := ""):
	if text != "":
		main.ui.display_move(text)
	main.ui.flavor_text.hide()
	main.cam.tween_cam_to(self)
	var tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(sprite, "position:y", 2, 0.3 / Methods.anim_speed).from(0)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "position:y", 0, 0.3 / Methods.anim_speed).from(2)
	await tween.finished
	return

func use_basic_attack(target: BattleCharacter):
	await start_action("Basic Attack")
	
	await main.skills.focus_on_target(target)
	target.health.take_damage(basic_attack, self)
	await Methods.wait(1.0 / Methods.anim_speed)
	
	Broadcaster.action_over.emit()

func use_defend():
	health.add_effect("Defend", 1.0)
	await start_action("Defend")
	Broadcaster.action_over.emit()

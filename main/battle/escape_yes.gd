extends BattleButton

@export var main: BattleScene

@onready var escape_animation: AnimationPlayer = $"../../../../EscapeScreen/EscapeAnimation"
@onready var rat_dance_anim: AnimationPlayer = $"../../../../EscapeScreen/RatDanceAnim"
@onready var walking: Sprite2D = $"../../../../EscapeScreen/Control/ratescape/Walking"
@onready var dead: Sprite2D = $"../../../../EscapeScreen/Control/ratescape/Dead"
@onready var escaping_text: RichTextLabel = $"../../../../EscapeScreen/Control/EscapingText"

func _on_pressed():
	var success = false
	if Global.battle_type in [0, 1]:
		success = true if randi_range(1, 100) <= Global.effective_escape_chance else false
	
	main.ui.close()
	await main.current_char.start_action("Escape")
	
	escape(success)

func escape(success):
	rat_dance_anim.play("rat_dance")
	escape_animation.play("escape")
	walking.show()
	dead.hide()
	escaping_text.text = "ESCAPING..."
	
	await Methods.wait(1.8 / Methods.anim_speed)
	
	if success:
		escaping_text.text = "ESCAPED!"
		main.escaped = true
	else:
		escaping_text.text = "FAILED!"
		main.escaped = false
		walking.hide()
		dead.show()
	
	await escape_animation.animation_finished
	
	Broadcaster.action_over.emit()

func _physics_process(delta: float) -> void:
	escape_animation.speed_scale = Methods.anim_speed

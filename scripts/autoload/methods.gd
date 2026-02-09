extends Node

var current_scene

var previous_talker := ""
var previous_position := Vector3(-1,-1,-1)

var anim_speed := 1.0

var skills_path_dict = {
	"Devour": "res://main/battle/skills/Devour.tscn",
	"Goop": "res://main/battle/skills/Goop.tscn",
	"Toxic Bite": "res://main/battle/skills/ToxicBite.tscn",
	"Dap Up": "res://main/battle/skills/DapUp.tscn"
}

func _ready():
	DialogueManager.connect("dialogue_ended", _on_dialogue_ended)

func _process(_delta):
	if Input.is_action_pressed("speed_up"):
		anim_speed = 2.0
	else:
		anim_speed = 1.0

func wait(time : float):
	await get_tree().create_timer(time).timeout
	return

func _on_dialogue_ended(dialogue):
	Global.dialogue_active = false

#TODO: Manage two different cases in overworld & battle
func tween_to_talker(talker_name: String, tween_time: float):
	if not current_scene:
		return

	if talker_name == previous_talker:
		return
	else:
		previous_talker = talker_name
	
	var talker = current_scene.get_talker(talker_name)
	if talker == null:
		printerr("Methods: No character found with inputted name")
	
	## Works differently in overworld and battle
	if current_scene is BattleScene:
		current_scene.cam.tween_cam_to(talker)
		return
	
	if previous_position == Vector3(-1,-1,-1):
		previous_position = current_scene.camera.position

	var destination = talker.position
	destination.z = talker.zoom
	destination.x += talker.offset

	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)

	tween.tween_property(current_scene.camera, "position", destination, tween_time)

func tween_to_normal(custom_cam_end: Vector3, tween_time: float):
	if not current_scene:
		return
	
	if current_scene is BattleScene:
		if current_scene.current_char == null:
			current_scene.cam.return_to_idle()
		return
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	var destination: Vector3
	if custom_cam_end != Vector3(-1,-1,-1):
		destination = custom_cam_end
	else:
		destination = previous_position
	tween.tween_property(current_scene.camera, "position", destination, tween_time)
	previous_position = Vector3(-1,-1,-1)
	previous_talker = ""

func buy_grimoire():
	Global.money -= 5
	Global.gob_sells_grimoire = true

func rgb_to_hex(r:int,g:int,b:int) -> String:
	return "#%02X%02X%02X" % [r, g, b]

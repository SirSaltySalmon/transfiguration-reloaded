extends Node

const OVERWORLD_PATH = "res://main/overworld/overworld_3d_main.tscn"
const BATTLE_PATH = "res://main/battle/battle.tscn"
const TITLE_PATH = "res://main/title/title.tscn"
const DATING_PATH = "res://main/dating/dating.tscn"

var current_scene

var previous_talker := ""
var previous_position := Vector3(-1,-1,-1)

var anim_speed := 1.0

signal flags_changed

signal dating_require_response

var last_fight_won := false

var hannes_strong_attack_next := false

var skills_path_dict = {
	"Devour": "res://main/battle/skills/Devour.tscn",
	"Goop": "res://main/battle/skills/Goop.tscn",
	"Toxic Bite": "res://main/battle/skills/ToxicBite.tscn",
	"Dap Up": "res://main/battle/skills/DapUp.tscn",
	"Judgment": "res://main/battle/skills/Judgment.tscn",
	"Cure": "res://main/battle/skills/Cure.tscn",
	"Bless": "res://main/battle/skills/bless.tscn",
	"Benevolence": "res://main/battle/skills/Benevolence.tscn",
	"Band For Band": "res://main/battle/skills/band_for_band.tscn",
	"Relentless Ridicule": "res://main/battle/skills/RelentlessRidicule.tscn",
	"Cross Slash": "res://main/battle/skills/CrossSlash.tscn",
	"Arrow Rain": "res://main/battle/skills/ArrowRain.tscn",
	"Eternal Pyre's Embrace": "res://main/battle/skills/EternalPyreEmbrace.tscn",
	"Icefall": "res://main/battle/skills/Icefall.tscn",
	"Rend": "res://main/battle/skills/Rend.tscn",
	"Gear Switch": "res://main/battle/skills/gear_switch.tscn",
	"Moonbeam": "res://main/battle/skills/moonbeam.tscn",
}

var area_resource_dict = {
	"sewers": "res://main/overworld/areas/sewers.tscn",
	"prison": "res://main/overworld/areas/prison.tscn",
	"library": "res://main/overworld/areas/library.tscn",
	"shop": "res://main/overworld/areas/shop.tscn",
	"dining_hall": "res://main/overworld/areas/dining_hall.tscn",
	"lair": "res://main/overworld/areas/lair.tscn"
}

func _ready():
	pass

func _process(_delta):
	if Input.is_action_pressed("speed_up"):
		anim_speed = 2.0
	else:
		anim_speed = 1.0

func wait(time : float):
	await get_tree().create_timer(time).timeout
	return

#TODO: Manage two different cases in overworld & battle
func tween_to_talker(talker_name: String, tween_time: float):
	if not current_scene:
		return
	
	if current_scene is DatingSim:
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

func tween_to_normal(tween_time: float):
	if not current_scene:
		return
	
	if current_scene is DatingSim:
		return
	
	if current_scene is BattleScene:
		if current_scene.current_char == null:
			current_scene.cam.return_to_idle()
		return
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	var destination = previous_position
	tween.tween_property(current_scene.camera, "position", destination, tween_time)
	previous_position = Vector3(-1,-1,-1)
	previous_talker = ""
	await tween.finished
	if not is_instance_valid(current_scene):
		return
	if current_scene is OverworldMain:
		if current_scene.active_cutscene_name != "":
			current_scene.anim.play()

func buy_grimoire():
	Global.sav.money -= 5
	Global.sav.gob_sells_grimoire = true

func log_money():
	Global.sav.money += 100
	Global.sav.money_at_jori = Global.sav.money

func check_money():
	if Global.sav.money <= Global.sav.money_at_jori - 100:
		return false
	return true

func enter_battle():
	DialogueManager.is_active = false
	SceneLoader.load_scene(BATTLE_PATH)

func enter_date():
	DialogueManager.is_active = false
	SceneLoader.load_scene(DATING_PATH)

func return_to_overworld(won: bool):
	DialogueManager.is_active = false
	last_fight_won = won
	if not won:
		Global.move_direction = ""
	SceneLoader.load_scene(OVERWORLD_PATH)

func return_to_title():
	DialogueManager.is_active = false
	SceneLoader.load_scene(TITLE_PATH)

func rgb_to_hex(r:int,g:int,b:int) -> String:
	return "#%02X%02X%02X" % [r, g, b]

func play_fx_overworld(pname: String):
	if current_scene is OverworldMain:
		current_scene.play_fx(pname)

func is_cutscene_playing():
	if current_scene is OverworldMain:
		if current_scene.active_cutscene_name != "":
			return true
	return false

func get_slime_texture() -> Texture2D:
	var size = Global.sav.size
	var texture = load("res://characters/slime/slime_%s.png" % str(size))
	return texture

func is_skill_enemy(id):
	return Global.sav.skills_data[id][2]

func is_skill_single_target(id):
	return Global.sav.skills_data[id][1]

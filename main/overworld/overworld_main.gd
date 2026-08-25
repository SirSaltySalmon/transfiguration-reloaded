class_name OverworldMain
extends Node3D

const DEVOUR = preload("uid://cvy25pxhxruyk")

@onready var camera = $Camera
@onready var ui = $OverworldUI
@onready var skip_button = $SkipButton
@onready var light = $Camera/OmniLight3D
@onready var env = $WorldEnvironment
@onready var vfx = $Effects/EffectsPlayer
@onready var cover = $Effects/Cover

@export var anim: AnimationPlayer

var area: Area

var loading_new_area = false
var area_load_status = 0
signal finished_loading

var active_cutscene_name = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Broadcaster.connect("move_to_area", move_to_area)
	Methods.current_scene = self
	skip_button.hide()
	if Methods.last_fight_won and Global.destination_area_id != "":
		finalize_move_to_area()
	else:
		reload()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if loading_new_area:
		area_load_status = ResourceLoader.load_threaded_get_status(Global.destination_resource)
		if area_load_status == ResourceLoader.THREAD_LOAD_LOADED:
			loading_new_area = false
			finished_loading.emit()

func move_to_area(area_id : String, resource : String, direction : String):
	Global.destination_area_id = area_id
	Global.destination_resource = resource
	Global.move_direction = direction
	
	if area_id == "lair":
		SoundManager.play_sound(SFX.GROUND_CRASH)
	
	await exit_transition()
	
	var battle = manage_battles()
	
	if battle:
		enter_battle()
	else:
		finalize_move_to_area()

func manage_battles():
	if not Global.sav.tutorial_fight_complete and Global.sav.current_area_id == "prison":
		Global.battle_type = 2
		return true
	if Global.sav.size == 7 and not Global.sav.size_7_intro_fight_complete:
		Global.battle_type = 1
		Global.sav.repellant_active = true # Automatically switches on repellant
		return true
	
	# No shadow wizards code here, handle separately
	# No hannes either
	
	# For other cases, which is random battles only
	if Global.sav.repellant_active:
		return false
	
	if Global.sav.size >= 5:
		if randi_range(1, 4) == 1:
			Global.battle_type = 1
			return true
	elif Global.sav.size >= 2:
		if randi_range(1, 4) == 1:
			Global.battle_type = 0
			return true
	
	return false

func finalize_move_to_area():
	#prefetch cutscene, a name will be returned if cutscene conditions are met
	var cutscene_name = manage_cutscenes()
	
	Global.transitioning = true #in case the ui still bugging during the load
	get_sky_and_light()
	
	ResourceLoader.load_threaded_request(Global.destination_resource)
	loading_new_area = true
	
	await finished_loading
	
	if is_instance_valid(area):
		area.queue_free()
	var area_res = ResourceLoader.load_threaded_get(Global.destination_resource)
	area = area_res.instantiate()
	area.hide()
	add_child(area)
	area.show()
	
	if cutscene_name:
		Global.transitioning = false
		play_cutscene(cutscene_name)
	else:
		SoundManager.play_sound(SFX.MOVE)
		enter_area()

func enter_area():
	area.normal_init_all()
	await enter_transition()
	area.show_arrows()
	
	Global.sav.current_area_id = Global.destination_area_id
	Global.sav.current_resource = Global.destination_resource
	Global.move_direction = ""
	Global.destination_area_id = ""
	Global.destination_resource = ""

func get_sky_and_light():
	if Global.sav.size == 7:
		env.environment = load("res://assets/overworld/effects/sky/size_7_sky.tres")
		light.light_color = Color("de6662")
		light.light_energy = 16.0
		return
	
	var id = Global.destination_area_id
	var sky_address = "res://assets/overworld/effects/sky/" + id + "_sky.tres"
	env.environment = load(sky_address)
	if id == "sewers" or id == "library":
		light.light_color = Color("6986c2")
		light.light_energy = 16.0
	elif id == "prison" or id == "shop":
		light.light_color = Color("ccb47a")
		light.light_energy = 16.0
	elif id == "dining_hall":
		light.light_color = Color("8AEF9E")
		light.light_energy = 3.0
	elif id == "lair":
		light.light_color = Color("c2c2c2")
		light.light_energy = 5.0

func enter_battle():
	Methods.enter_battle()

func exit_transition():
	Global.transitioning = true
	start_transition(true)
	await Methods.wait(1)
	Global.transitioning = false
	return

func enter_transition():
	Global.transitioning = true
	start_transition(false)
	await Methods.wait(1)
	Global.transitioning = false
	return

func start_transition(is_exit: bool):
	Global.transitioning = true
	var tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_ease(Tween.EASE_IN if is_exit else Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_parallel(true)
	
	var dir = Global.move_direction
	var position_value = 25  # Default position value
	var axis = ""
	
	# Determine axis and position value based on direction
	match dir:
		"up":
			axis = "position:y"
			position_value = 25 if is_exit else -25
		"down":
			axis = "position:y"
			position_value = -25 if is_exit else 25
		"left":
			axis = "position:x"
			position_value = -camera.MAX_DISTANCE - 25 if is_exit else camera.MAX_DISTANCE + 25
		"right":
			axis = "position:x"
			position_value = camera.MAX_DISTANCE + 25 if is_exit else -camera.MAX_DISTANCE - 25
		_:  # Default case (for null direction)
			axis = "position:z"
			position_value = 25 if is_exit else 50
	
	# Set up the camera movement tween
	if axis == "position:z" and !is_exit:
		tween.tween_property(camera, axis, 0, 1).from(position_value)
		camera.position.x = 0
		camera.position.y = 0
	elif !is_exit:
		tween.tween_property(camera, axis, 0, 1).from(position_value)
		fix_camera(axis)
	else:
		tween.tween_property(camera, axis, position_value, 1)
		fix_camera(axis)
	
	# Set up the color fade tween
	var from_color = Color(Color.BLACK, 0) if is_exit else Color.BLACK
	var to_color = Color.BLACK if is_exit else Color(Color.BLACK, 0)
	
	color_transition(is_exit)

func color_transition(is_exit: bool):
	if is_exit:
		vfx.play("exit")
	else:
		vfx.play("enter")

func fix_camera(axis):
		if axis == "position:x":
			camera.position.y = 0
		camera.position.z = 0

func reload():
	Global.destination_area_id = Global.sav.current_area_id
	Global.destination_resource = Global.sav.current_resource
	
	finalize_move_to_area()

func manage_cutscenes():
	if not Global.sav.cutscene_1 and Global.destination_area_id == "sewers":
		return "cutscene_1"
	if not Global.sav.jori_intro and Global.destination_area_id == "lair":
		return "cutscene_2"
	if Global.sav.size == 7 and Global.destination_area_id == "dining_hall":
		return "cutscene_3"
	return null

func play_cutscene(cutscene_name: String):
	ui.hide()
	skip_button.show()
	for child in area.get_children():
		if child.is_in_group(cutscene_name) or child.name == "Background":
			child.show()
		else:
			child.hide()
	anim.clear_caches() # Attempt to help make the animation not break when scenes are loaded in
	anim.play(cutscene_name)
	active_cutscene_name = cutscene_name

func end_cutscene():
	if is_instance_valid(DialogueManager.active_balloon):
		DialogueManager.active_balloon.queue_free()
	anim.stop()
	Global.sav.set(active_cutscene_name, true)
	for child in area.get_children():
		if child.is_in_group(active_cutscene_name) and child.name != "Background":
			child.hide()
	var continue_in_normal_play = perform_end_of_cutscene_function(active_cutscene_name)
	active_cutscene_name = ""
	if continue_in_normal_play:
		ui.show()
		skip_button.hide()
		finalize_move_to_area()

func perform_end_of_cutscene_function(cutscene_name):
	if cutscene_name == "cutscene_1":
		#No special function
		return true
	elif cutscene_name == "cutscene_2":
		Methods.enter_date()
	elif cutscene_name == "cutscene_3":
		Global.battle_type = 4
		Methods.enter_battle()

func play_fx(fx_name: String):
	vfx.stop()
	vfx.play(fx_name)
	if fx_name == "devour":
		SoundManager.play_sound(DEVOUR)

func get_talker(talker_name: String):
	return area.find_child(talker_name)

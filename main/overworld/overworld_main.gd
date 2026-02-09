extends Node3D

@onready var camera = $Camera
@onready var ui = $OverworldUI
@onready var light = $Camera/OmniLight3D
@onready var env = $WorldEnvironment
@onready var anim = $AnimationPlayer

var area

var loading_new_area = false
var area_load_status = 0
signal finished_loading

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Broadcaster.connect("move_to_area", move_to_area)
	Methods.current_scene = self
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
	
	await exit_transition()
	
	var battle = manage_battles()
	
	if battle:
		enter_battle()
	else:
		finalize_move_to_area()

func manage_battles():
	if Global.just_size_2 and Global.current_area_id == "prison":
		Global.battle_type = 2
		return true
	
	# Handle shadow wizards separately
	if Global.size == 7 and Global.destination_area_id == "dining_hall":
		Global.battle_type = 4
		return true
	
	# For other cases
	if Global.size >= 2:
		if not Global.repellant_active and randi_range(1, 4) == 1:
			return true
	
	return false

func finalize_move_to_area():
	Global.current_area_id = Global.destination_area_id
	#prefetch cutscene, a name will be returned if cutscene conditions are met
	var cutscene_name = cutscene_manager()
	
	Global.transitioning = true #in case the ui still bugging during the load
	get_sky_and_light()
	
	ResourceLoader.load_threaded_request(Global.destination_resource)
	loading_new_area = true
	
	await finished_loading
	
	area = ResourceLoader.load_threaded_get(Global.destination_resource)
	area = area.instantiate()
	add_child(area)
	
	if cutscene_name:
		play_cutscene(cutscene_name)
	else:
		enter_area()

func enter_area():
	area.normal_init_all()
	await enter_transition()
	
	Global.current_resource = Global.destination_resource
	Global.move_direction = ""
	Global.destination_area_id = ""
	Global.destination_resource = ""

func get_sky_and_light():
	var id = Global.destination_area_id
	var sky_address = "res://assets/overworld/effects/sky/" + id + "_sky.tres"
	env.environment = load(sky_address)
	if id == "sewers":
		light.light_color = Color("6986c2")
	elif id == "prison" or id == "shop":
		light.light_color = Color("ccb47a")

func enter_battle():
	pass

func exit_transition():
	start_transition(true)
	await Methods.wait(1)
	area.queue_free()
	Global.transitioning = false
	return

func enter_transition():
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
	elif !is_exit:
		tween.tween_property(camera, axis, 0, 1).from(position_value)
	else:
		tween.tween_property(camera, axis, position_value, 1)
	
	# Set up the color fade tween
	var from_color = Color(Color.BLACK, 0) if is_exit else Color.BLACK
	var to_color = Color.BLACK if is_exit else Color(Color.BLACK, 0)
	
	if is_exit:
		tween.tween_property(ui.cover, "color", to_color, 1)
	else:
		tween.tween_property(ui.cover, "color", to_color, 1).from(from_color)

func reload():
	Global.destination_area_id = Global.current_area_id
	Global.destination_resource = Global.current_resource
	
	finalize_move_to_area()

func cutscene_manager():
	if not Global.cutscene_1 and Global.current_area_id == "sewers":
		#return "cutscenes/1"
		pass
	return null

func play_cutscene(cutscene_name: String):
	anim.play(cutscene_name)
	var name_fixed = cutscene_name.replace("/","")
	for child in area.get_children():
		if child.is_in_group(name_fixed) or child.name == "Background":
			child.show()
		else:
			child.hide()

func end_cutscene(cutscene_name: String):
	if cutscene_name == "cutscenes/1":
		Global.cutscene_1 = true
	enter_area()

func get_talker(talker_name: String):
	return area.find_child(talker_name)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if "cutscenes" in anim_name:
		end_cutscene(anim_name)

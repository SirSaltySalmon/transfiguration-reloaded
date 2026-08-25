extends Node

var sav: SaveGame = null

const SAVE_STATE_PATH := "user://SILVERANCE_SAVE.tres"
const NO_VERSION_NAME = "0.0.0"

var has_save := false

signal preparing_to_save

func _ready():
	has_save = true if _load_current_save() else false

func reset() -> void:
	sav = SaveGame.new()

func open():
	_log_version()
	save()

func get_current_ver() -> String:
	return ProjectSettings.get_setting("application/config/version", NO_VERSION_NAME)

func _log_time() -> void:
	if sav != null:
		sav.last_unix_time_saved = int(Time.get_unix_time_from_system())

func _log_version() -> void:
	if sav != null:
		var current_version = get_current_ver()
		if current_version.is_empty():
			current_version = NO_VERSION_NAME
		if not sav.first_version_opened:
			sav.first_version_opened = current_version
		sav.last_version_opened = current_version

func _load_current_save() -> bool:
	#sav = SaveGame.new()
	#return false
	
	if FileAccess.file_exists(SAVE_STATE_PATH):
		sav = ResourceLoader.load(SAVE_STATE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	if not sav:
		print("No save game exists. Loading new game instead")
		sav = SaveGame.new()
		return false
	return true

func save() -> void:
	_log_time()
	if sav != null:
		preparing_to_save.emit()
		ResourceSaver.save(sav, SAVE_STATE_PATH)
	else:
		printerr("Attempting to save when no save file is present")

#General tracker variables, used during gameplay, but are not needed to save.
var destination_area_id : StringName
var destination_resource : StringName
var move_direction : StringName
var transitioning := false
var effective_escape_chance: int
var custom_talker : StringName
var battle_type := 3
#0 : Random low level battle
#1 : Random high level battle
#2 : Tutorial battle
#3 : Shadow wizards - Boss
#4 : Hannes - Final boss

class_name DatingSim
extends Node2D

const DATING = preload("uid://ds73q7xqpmjj0")
const SPOTLIGHT = preload("uid://ivr65xk0jxhm")

const LARGE_IMPACT = preload("uid://cgv60uv5ol5oi")
const GLASS = preload("uid://b6dgqijm875t5")
const CHEERY_TUNE = preload("uid://nqveqbqrc5fs")

@onready var jori: Sprite2D = $Jori
@onready var jori_campfire: Sprite2D = $CampfireBG/JoriCampfire
@onready var jori_anim: AnimationPlayer = $Jori/JoriAnim
@onready var alpha_anim: AnimationPlayer = $Jori/AlphaAnim
@onready var main_anim: AnimationPlayer = $MainAnim
@onready var effects_player: AnimationPlayer = $Effects/EffectsPlayer

@export var dialogue_res: DialogueResource
@export var balloon_scene: PackedScene

const emo_dict = {
	"neutral": 0,
	"annoyed": 1,
	"happy": 2,
	"smug": 3,
}

const campfire_dict = {
	"neutral": 3,
	"sad_minor": 2,
	"crying_into": 1,
	"crying_away": 0,
}

var balloon: DatingBalloon

func _ready():
	Methods.current_scene = self
	
	main_anim.play("intro")
	await main_anim.animation_finished
	if not Global.sav.jori_intro:
		balloon = DialogueManager.show_dialogue_balloon_scene(balloon_scene, dialogue_res, "jori_intro")
	else:
		balloon = DialogueManager.show_dialogue_balloon_scene(balloon_scene, dialogue_res, "jori_branch")
	
	SoundManager.play_music(DATING)
	
	%Auto.enable()
	%Skip.enable()

func show_jori(code: String):
	alpha_anim.stop()
	alpha_anim.play("show")
	jori_emo(code)

func jori_emo(code: String):
	jori.frame = emo_dict[code]
	jori_anim.stop()
	jori_anim.play("bounce")

func enter_headpat():
	effects_player.play("headpat_show")

func exit_headpat():
	effects_player.play("headpat_hide")

func play_grass_cracking_sound():
	SoundManager.pause_music(DATING)
	SoundManager.play_sound(GLASS)

func continue_music():
	SoundManager.resume_music_with_fade(DATING, 1.0)

func show_campfire(code: String):
	campfire_emo(code)
	effects_player.play("campfire_show")

func campfire_emo(code: String):
	jori_campfire.frame = campfire_dict[code]

func show_flame():
	SoundManager.stop_music()
	%FakeTimeSys.hide()
	%Cover.show()
	%Cover.color = Color.BLACK
	await Methods.wait(2.0)
	SoundManager.play_sound(SPOTLIGHT)
	%Flame.show()
	%Cover.hide()

func stop_auto_and_skip():
	%Auto.toggle_off()
	%Skip.toggle_off()
	%Auto.disable()
	%Skip.disable()

func skip_text_at_end():
	await balloon.dialogue_label.finished_typing
	balloon.force_input()

func date_death():
	# No flags triggered
	SoundManager.stop_music(1.0)
	stop_auto_and_skip()
	DialogueManager.is_active = false
	effects_player.stop()
	effects_player.play("death")
	SoundManager.play_sound(LARGE_IMPACT)
	await effects_player.animation_finished
	Methods.return_to_overworld(false)

func exit_date():
	SoundManager.stop_music(1.0)
	stop_auto_and_skip()
	Global.sav.jori_intro = true # Got out peacefully
	DialogueManager.is_active = false
	effects_player.stop()
	effects_player.play("exit")
	await effects_player.animation_finished
	Methods.return_to_overworld(true)

func devour_jori():
	stop_auto_and_skip()
	Global.sav.size = 7
	Global.sav.bt_slime_skills[2] = "Eternal Pyre's Embrace"
	DialogueManager.is_active = false
	SoundManager.play_sound(CHEERY_TUNE)
	%Video.show()
	%Video.play()
	await %Video.finished
	effects_player.stop()
	effects_player.play("death")
	SoundManager.play_sound(LARGE_IMPACT)
	%Video.hide()
	await effects_player.animation_finished
	Methods.return_to_overworld(true)
	

func date_bad_end():
	stop_auto_and_skip()
	SoundManager.pause_music(DATING)
	for i in range(25):
		SoundManager.play_music_from_position(DATING, 0.0)
		await Methods.wait(0.2)
	SoundManager.stop_music()
	date_death()

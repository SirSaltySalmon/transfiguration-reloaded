class_name DatingSim
extends Node2D

@onready var jori: Sprite2D = $Jori
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

var balloon: DatingBalloon

func _ready():
	Methods.current_scene = self
	
	main_anim.play("intro")
	await main_anim.animation_finished
	if not Global.sav.jori_intro:
		balloon = DialogueManager.show_dialogue_balloon_scene(balloon_scene, dialogue_res, "jori_intro")
	else:
		balloon = DialogueManager.show_dialogue_balloon_scene(balloon_scene, dialogue_res, "jori_branch")
	
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
	pass

func exit_headpat():
	pass

func play_grass_cracking_sound():
	pass

func show_campfire(code: String):
	pass

func campfire_emo(code: String):
	pass

func stop_auto_and_skip():
	%Auto.toggle_off()
	%Skip.toggle_off()
	%Auto.disable()
	%Skip.disable()

func date_death():
	# No flags triggered
	stop_auto_and_skip()
	effects_player.stop()
	effects_player.play("death")
	await effects_player.animation_finished
	Methods.return_to_overworld(false)

func exit_date():
	stop_auto_and_skip()
	Global.sav.jori_intro = true # Got out peacefully
	effects_player.stop()
	effects_player.play("exit")
	await effects_player.animation_finished
	Methods.return_to_overworld(true)

func date_bad_end():
	stop_auto_and_skip()
	# Chop audio
	# Show evil screen, unskippable for 5 seconds
	date_death()

class_name BattleUI
extends Control

@export var anim: AnimationPlayer
@export var vignette: Vignette
@export var move_displayer: RichTextLabel
@export var move_container: MarginContainer
@export var left_panel: BattlePanel
@export var right_panel: BattlePanel
@export var solid_color: ColorRect
@export var intro_fight: RichTextLabel

@export var skill_desc_handler: SkillDescriptionHandler
@export var skill_node_connector: SkillNodeConnector
@export var item_sprite: Sprite2D
@export var item_description: RichTextLabel
@export var escape_chance_display: RichTextLabel

@export var flavor_text: FlavorText

var closed := true

func display_move(text: String):
	move_displayer.text = text
	move_container.show()
	var tween = get_tree().create_tween()
	tween.tween_property(move_displayer, "modulate", Color(Color.WHITE, 1.0), 0.3 / Methods.anim_speed).from(Color(Color.WHITE, 0.0))

func hide_move():
	move_container.hide()

func toggle_closed():
	closed = true

func toggle_open():
	closed = false

func close():
	anim.play("ui_close")

func open():
	anim.play("ui_open")

func change_to(id: String):
	if not closed:
		anim.play("ui_close", -1, 2.0)
		await anim.animation_finished
	
	for child in left_panel.get_children():
		child.hide()
	for child in right_panel.get_children():
		child.hide()
	right_panel.hide_quill()
	
	match id:
		"options":
			left_panel.options.show()
			left_panel.return_button.hide()
			right_panel.options.show()
			right_panel.scroll.hide()
		"skills":
			left_panel.skills.show()
			left_panel.return_button.show()
			right_panel.skills.show()
			right_panel.scroll.show()
			
			skill_desc_handler.reset()
			skill_node_connector.update_skill_options()
		"items":
			left_panel.items.show()
			left_panel.return_button.show()
			right_panel.items.show()
			right_panel.scroll.show()
			
			item_sprite.show()
			item_sprite.frame = 0
			item_description.text = "Select an item"
		"escape":
			left_panel.escape.show()
			left_panel.return_button.show()
			right_panel.escape.show()
			right_panel.scroll.show()
			
			escape_chance_display.chance_update()
	
	anim.play("ui_open")
	return
	

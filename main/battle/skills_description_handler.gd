class_name SkillDescriptionHandler extends Control

@export var magic_circle_sprite: Sprite2D
@export var skill_desc: RichTextLabel

func reset():
	skill_desc.hide()
	magic_circle_sprite.show()
	
func show_desc(desc_text: String):
	magic_circle_sprite.hide()
	skill_desc.text = desc_text
	skill_desc.show()

class_name ItemsButton extends BattleButton

@export var item_sprite: Sprite2D
@export var item_desc_display: RichTextLabel

@export var item_name: String
@export var item_id: String
@export var sprite_id: int
@export var item_desc: String

@export var main: BattleScene

var count = 0

func _process(_delta):
	count = Global.get(item_id)
	if count > 0:
		#eg Cured Ham x20
		text = item_name + " x" + str(count)
	else:
		text = "- Empty -"

func _on_mouse_entered():
	super()
	if count <= 0:
		return
	item_sprite.frame = sprite_id
	item_desc_display.text = item_desc
	
	

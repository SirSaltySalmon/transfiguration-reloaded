extends BattleCharacter

@export var vertical_sprite: Sprite3D

func _ready():
	super()
	sprite.texture = Methods.get_slime_texture()
	if Global.sav.size == 7:
		sprite.scale = Vector3(0.6, 0.6, 0.6)
	else:
		sprite.scale = Vector3(0.2, 0.2, 0.2)

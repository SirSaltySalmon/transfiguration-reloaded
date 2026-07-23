extends BattleCharacter

func _ready():
	super()
	sprite.texture = Methods.get_slime_texture()

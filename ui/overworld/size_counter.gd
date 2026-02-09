extends RichTextLabel

func _process(_delta: float) -> void:
	text = " [color=cyan]Size:[/color] " + str(Global.size)

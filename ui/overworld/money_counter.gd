extends RichTextLabel

func _process(_delta: float) -> void:
	text = " [color=gold]Money:[/color] " + str(Global.money)

extends RichTextLabel

func chance_update():
	if Global.battle_type in [0, 1]:
		Global.effective_escape_chance = Global.sav.base_escape_chance + randi_range(-10, 10)
		var green_proportion = ((clamp(Global.effective_escape_chance, 30, 70) - 30) / 40.0)
		var red_proportion = 1.0 - green_proportion
		var hex_code: String
		if red_proportion > green_proportion:
			var red = 255
			var green = int(green_proportion / red_proportion * 255)
			hex_code = Methods.rgb_to_hex(red, green, 0)
		else:
			var green = 255
			var red = int(red_proportion / green_proportion * 255)
			hex_code = Methods.rgb_to_hex(red, green, 0)
		text = "Escape chance - [color=" + hex_code + "]" + str(Global.effective_escape_chance) + "%"
	else:
		text = "Mandatory fight! Escape will fail."

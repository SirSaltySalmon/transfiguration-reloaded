extends Label

func _physics_process(delta: float) -> void:
	var date = Time.get_datetime_dict_from_system()
	var weekday
	match date["weekday"]:
		0: weekday = "Sunday"
		1: weekday = "Monday"
		2: weekday = "Tuesday"
		3: weekday = "Wednesday"
		4: weekday = "Thursday"
		5: weekday = "Friday"
		6: weekday = "Saturday"
		7: weekday = "Sunday"
		_: weekday = "Sunday"
		
	text = weekday + " " + str(date["day"]) + "/" + str(date["month"])

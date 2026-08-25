extends HealthComponent

func death():
	super()
	main.queue_dialogue("shadow_wizards_b_died")

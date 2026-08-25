extends HealthComponent

func death():
	super()
	main.queue_dialogue("shadow_wizards_a_died")

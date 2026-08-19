extends HealthComponent

func death():
	super()
	parent.trigger_hannes_death()

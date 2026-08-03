extends BattleCharacter

func skill_action():
	var targets = main.get_alive_allies()
	
	assert(skill_component)
	var skill = skill_component.skills.pick_random()
	match skill.id:
		"Band For Band":
			skill.use(self, targets)
		"Relentless Ridicule":
			skill.use(self, targets.pick_random())
		_:
			printerr("AI can't match correct skill! Inspect for character " + str(name))
			super()

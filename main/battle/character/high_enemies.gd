extends BattleCharacter

func skill_action():
	var skill = skill_component.skills.pick_random()
	var targets
	if Methods.is_skill_enemy(skill.id):
		targets = main.get_alive_allies()
	else:
		targets = main.get_alive_enemies()
		
	if Methods.is_skill_single_target(skill.id):
		targets = targets.pick_random()
	
	skill.use(self, targets)

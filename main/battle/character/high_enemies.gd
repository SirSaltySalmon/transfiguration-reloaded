extends BattleCharacter

func skill_action():
	var skill = skill_component.skills.pick_random()
	use_skill(skill)

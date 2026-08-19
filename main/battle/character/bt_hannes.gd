extends BattleCharacter

@onready var vertical_sprite: Sprite3D = $CharacterVisual/VerticalSprite

var gearswitched := false
const PHASE_2_THRESHOLD := 650
var phase_2 := false

var action_counter := 0

func _ready():
	super()
	health.bar.connect("value_changed", on_health_changed)

func on_health_changed(value):
	if value <= PHASE_2_THRESHOLD and not phase_2:
		trigger_phase_2()

func trigger_phase_2():
	phase_2 = true
	turn.force_action()
	health.add_effect("Bless", 99)
	sprite.frame = 1
	vertical_sprite.frame = 1
	speed += 20
	action_counter = 0
	turn.update_speed()

func ai_action():
	action_counter += 1
	if not phase_2:
		if action_counter == 3:
			use_skill(skill_component.skills[2]) # Icefall
			action_counter = 0
		elif action_counter == 2:
			use_skill(skill_component.skills[1]) # Rend
		else:
			use_skill(skill_component.skills[4]) # Ridicule
	else:
		if not gearswitched:
			use_skill(skill_component.skills[0]) # Gear Switch
			action_counter = 0
			return
		elif action_counter == 3:
			use_skill(skill_component.skills[3]) # Moonbeamm
			action_counter = 0
		elif action_counter == 2:
			use_skill(skill_component.skills[1]) # Rend
		else:
			use_skill(skill_component.skills[4]) # Ridicule
	
	Methods.hannes_strong_attack_next = true if action_counter == 2 else false

func trigger_hannes_death():
	pass

extends Skill

const GEARSWITCH = preload("uid://m55u7uxqsxvf")
const COLD_NIGHT_SKY = preload("uid://m5stumg57fng")

func _ready():
	super()
	center.cine_anim.add_animation_library("gearswitch", GEARSWITCH)

func use(user: BattleCharacter, target):
	await user.start_action("Gear Switch")
	
	main.env.environment = COLD_NIGHT_SKY
	user.gearswitched = true
	center.cine_anim.play("gearswitch/play", -1, Methods.anim_speed)
	
	await center.cine_anim.animation_finished
	
	Broadcaster.action_over.emit()

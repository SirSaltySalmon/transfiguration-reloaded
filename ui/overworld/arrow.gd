extends StaticBody3D

@onready var outline = $ArrowMesh/Outline

@export var direction : String
@export var destination : String
@export var resource : String
@export var show_condition : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func initialize_arrow():
	if show_condition and destination:
		if evaluate_condition(show_condition):
			show()
		else:
			hide()
	else:
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func highlight():
	if !outline.visible:
		outline.show()
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func unhighlight():
	outline.hide()
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
func interact():
	if not Global.cutscene_playing and not Global.dialogue_active and visible:
		Broadcaster.bc_move_to_area(destination, resource, direction)
	
# Function that takes a string condition and evaluates it as a boolean expression
func evaluate_condition(input: String) -> bool:
	# Create a new GDScript instance
	var script = GDScript.new()
	# Dynamically create a function named 'eval' which returns the boolean condition passed as a string
	script.set_source_code("func eval() -> bool:\n\treturn " + input)
	# Reload the script to compile it
	if script.reload() != OK:
		print("Error compiling the script.")
		return false
	# Create an instance of the dynamically created script
	var ref = RefCounted.new()
	ref.set_script(script)
	# Call the eval function to execute the condition
	return ref.eval()

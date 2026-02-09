class_name FlavorText extends RichTextLabel
## The speed with which the text types out.
@export var seconds_per_step: float = 0.02

## Automatically have a brief pause when these characters are encountered.
@export var pause_at_characters: String = ".?!"

## Don't auto pause if the character after the pause is one of these.
@export var skip_pause_at_character_if_followed_by: String = ")\""

## Don't auto pause after these abbreviations (only if "." is in `pause_at_characters`).[br]
## Abbreviations are limitted to 5 characters in length [br]
## Does not support multi-period abbreviations (ex. "p.m.")
@export var skip_pause_at_abbreviations: PackedStringArray = ["Mr", "Mrs", "Ms", "Dr", "etc", "eg", "ex"]

## The amount of time to pause when exposing a character present in `pause_at_characters`.
@export var seconds_per_pause_step: float = 0.3

## The current line of dialogue.
var dialogue_line:
	set(next_dialogue_line):
		dialogue_line = next_dialogue_line
		custom_minimum_size = Vector2.ZERO
		text = ""
		text = dialogue_line.text
	get:
		return dialogue_line

## Whether the label is currently typing itself out.
var is_typing: bool = false:
	get:
		return is_typing

var _last_wait_index: int = -1
var _waiting_seconds: float = 0

func _ready():
	write("")

func _process(delta: float) -> void:
	if self.is_typing:
		# Type out text
		if visible_ratio < 1:
			# See if we are waiting
			if _waiting_seconds > 0:
				_waiting_seconds = _waiting_seconds - delta
			# If we are no longer waiting then keep typing
			if _waiting_seconds <= 0:
				_type_next(delta, _waiting_seconds)
		else:
			self.is_typing = false


func write(line) -> void:
	hide()
	dialogue_line = DialogueLine.new()
	dialogue_line.text = line
	show()
	if not dialogue_line.text.is_empty():
		type_out()

## Start typing out the text
func type_out() -> void:
	text = dialogue_line.text
	visible_characters = 0
	visible_ratio = 0
	_waiting_seconds = 0
	_last_wait_index = -1

	self.is_typing = true

	if get_total_character_count() == 0:
		self.is_typing = false
	elif seconds_per_step == 0:
		visible_characters = get_total_character_count()
		self.is_typing = false

# Type out the next character(s)
func _type_next(delta: float, seconds_needed: float) -> void:
	if visible_characters == get_total_character_count():
		return

	var additional_waiting_seconds: float = _get_pause(visible_characters)

	# Pause on characters like "."
	if _should_auto_pause():
		additional_waiting_seconds += seconds_per_pause_step
	
	
	visible_characters += 1
	if visible_characters <= get_total_character_count():
		seconds_needed += seconds_per_step * (1.0 / _get_speed(visible_characters))
		if seconds_needed > delta:
			_waiting_seconds += seconds_needed
		else:
			_type_next(delta, seconds_needed)


# Get the pause for the current typing position if there is one
func _get_pause(at_index: int) -> float:
	return dialogue_line.pauses.get(at_index, 0)


# Get the speed for the current typing position
func _get_speed(at_index: int) -> float:
	var speed: float = 1
	for index in dialogue_line.speeds:
		if index > at_index:
			return speed
		speed = dialogue_line.speeds[index]
	return speed


# Determine if the current autopause character at the cursor should qualify to pause typing.
func _should_auto_pause() -> bool:
	if visible_characters == 0: return false

	var parsed_text: String = get_parsed_text()

	# Avoid outofbounds when the label auto-translates and the text changes to one shorter while typing out
	# Note: visible characters can be larger than parsed_text after a translation event
	if visible_characters >= parsed_text.length(): return false

	# Ignore pause characters if they are next to a non-pause character
	if parsed_text[visible_characters] in skip_pause_at_character_if_followed_by.split():
		return false

	# Ignore "." if it's between two numbers
	if visible_characters > 3 and parsed_text[visible_characters - 1] == ".":
		var possible_number: String = parsed_text.substr(visible_characters - 2, 3)
		if str(float(possible_number)).pad_decimals(1) == possible_number:
			return false

	# Ignore "." if it's used in an abbreviation
	# Note: does NOT support multi-period abbreviations (ex. p.m.)
	if "." in pause_at_characters and parsed_text[visible_characters - 1] == ".":
		for abbreviation in skip_pause_at_abbreviations:
			if visible_characters >= abbreviation.length():
				var previous_characters: String = parsed_text.substr(visible_characters - abbreviation.length() - 1, abbreviation.length())
				if previous_characters == abbreviation:
					return false

	# Ignore two non-"." characters next to each other
	var other_pause_characters: PackedStringArray = pause_at_characters.replace(".", "").split()
	if visible_characters > 1 and parsed_text[visible_characters - 1] in other_pause_characters and parsed_text[visible_characters] in other_pause_characters:
		return false

	return parsed_text[visible_characters - 1] in pause_at_characters.split()

class_name TargetSelection extends Node

@export var main: BattleScene

signal confirmed_selection

# Selection state
var current_target: BattleCharacter
var current_index: int = 0
var available_targets: Array[BattleCharacter]
var is_selecting_one: bool = false
var is_active: bool = false

#region Public API
func random_target(characters: Array[BattleCharacter]) -> BattleCharacter:
	if characters.is_empty():
		return null
	return characters[randi_range(0, characters.size() - 1)]

func select_target(characters: Array[BattleCharacter], single: bool):
	if single:
		return await select_one_target(characters)
	else:
		return await select_all_targets(characters)

func select_one_target(characters: Array[BattleCharacter]) -> BattleCharacter:
	if characters.is_empty():
		return null
	
	_start_selection(characters, true)
	_focus_on_target(current_target)
	_indicate_target(current_target)
	
	await confirmed_selection
	
	is_active = false
	if current_target:
		current_target.visual.hide_indicator()
	return current_target

func select_all_targets(characters: Array[BattleCharacter]) -> Array[BattleCharacter]:
	if characters.is_empty():
		return []
	
	_start_selection(characters, false)
	_focus_on_targets(characters)
	_indicate_target(characters)
	
	await confirmed_selection
	
	is_active = false
	if available_targets:
		for target in available_targets:
			target.visual.hide_indicator()
	return available_targets
#endregion

#region Input Handling
func _input(event: InputEvent) -> void:
	if not is_active:
		return
	
	if event.is_action_pressed("ui_accept"):
		_confirm_selection()
	elif event.is_action_pressed("ui_cancel"):
		_cancel_selection()
	elif is_selecting_one:
		_handle_navigation_input(event)

func _handle_navigation_input(event: InputEvent) -> void:
	if available_targets.size() <= 1:
		return
	
	var direction = 0
	if event.is_action_pressed("ui_left"):
		direction = 1
	elif event.is_action_pressed("ui_right"):
		direction = -1
	
	if direction != 0:
		_move_selection(direction)

func _move_selection(direction: int) -> void:
	
	current_index = wrapi(current_index + direction, 0, available_targets.size())
	current_target = available_targets[current_index]
	
	_focus_on_target(current_target)
	_indicate_target(current_target)

func _confirm_selection() -> void:
	confirmed_selection.emit()

func _cancel_selection() -> void:
	current_target.visual.hide_indicator()
	for target in available_targets:
		target.visual.hide_indicator()
	current_target = null
	is_active = false
	available_targets.clear()
	confirmed_selection.emit()
	main.cancel_selection()
#endregion

#region Private Helpers
func _start_selection(characters: Array[BattleCharacter], single_target: bool) -> void:
	is_selecting_one = single_target
	is_active = true
	available_targets = characters.duplicate()
	current_index = 0
	
	if single_target and not characters.is_empty():
		current_target = characters[0]
	
	main.ui.close()

func _focus_on_target(target: BattleCharacter) -> void:
	if target and main.cam:
		main.cam.tween_cam_to(target)

func _focus_on_targets(targets: Array[BattleCharacter]) -> void:
	if not targets.is_empty() and main.cam:
		main.cam.tween_cam_to(targets)

func _indicate_target(target) -> void:
	if target is BattleCharacter:
		target.visual.indicate(false)
		return
	else:
		for char in target:
			_indicate_target(target)
		return

#endregion

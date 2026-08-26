@icon("res://addons/at-icons/node/arrow_axes_4d.svg")
class_name StateMachine
extends Node

@export var beginning_state: State

var _states: Array[State] = []
var _current_state: State = null
var _changing_state: bool = false
var _can_change_state: bool = true

signal state_changed(old_state_name: String, new_state_name: String)

func _ready() -> void:
	assert(beginning_state != null, "STATE MACHINE: Beginning state not set.")
	
	_scan_states()
	_change_state(beginning_state.name)
	
func _input(event: InputEvent) -> void:
	if _changing_state: return
	
	_current_state.input_event(event)
	
func _process(delta: float) -> void:
	_current_state.frames(delta)
	
	if _changing_state: return
	
	_current_state.input_process(delta)
	
func _physics_process(delta: float) -> void:
	if _changing_state: return
	
	_current_state.physics(delta)
	
## Filters this node's children for [State] nodes and saves them to [member StateMachine.states].
func _scan_states() -> void:
	for child in get_children():
		if child is State:
			_states.append(child as State)
	
	assert(len(_states) != 0, "STATE MACHINE: State machine has no states.")
	
## Finds state in [member StateMachine.states] by its node name.
## [br][br]
## Takes [String] [param state_name] for the name of the new state's node.
func _find_state_by_name(state_name: String) -> State:
	var filtered_states: Array[State] = _states.filter(func(s): return s.name == state_name)
	assert(len(filtered_states) == 1, "STATE MACHINE: Could not pinpoint state with name '%s'. Found %d states." % [state_name, len(filtered_states)])
	
	return filtered_states.front() as State
	
## Invoked when [signal StateMachine.request_state_change] is emitted.
## Changes [member StateMachine.current_state] to a new state based on new state's node name.
## [br][br]
## Takes [String] [param new_state_name] for the name of the new state's node.
func _change_state(new_state_name: String) -> void:
	_changing_state = true
	
	var old_state_name: String = _current_state.name if _current_state != null else ""
	var new_state: State = _find_state_by_name(new_state_name)
	
	if _current_state:
		_current_state.exit()
	_current_state = new_state
	
	state_changed.emit(old_state_name, new_state_name)
	_current_state.enter()
	
	_changing_state = false
	
## Changes this entity's state using its state machine
## Takes [String] [param new_state_name] for the name of the new state's node.
func change_state(new_state_name: String) -> void:
	if not _can_change_state or _changing_state: return
	
	_change_state(new_state_name)

func set_can_change_state(is_enabled: bool) -> void:
	_can_change_state = is_enabled
	
func can_change_state() -> bool:
	return _can_change_state

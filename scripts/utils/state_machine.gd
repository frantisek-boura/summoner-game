@icon("res://addons/at-icons/node/arrow_axes_4d.svg")
class_name StateMachine
extends Node

@export var beginning_state: State
@export var default_state: State

var can_change: bool = true

var _states: Array[State] = []
var _current_state: State = null
var _changing_state: bool = false

signal state_changed(old_state_name: String, new_state_name: String)

func _ready() -> void:
	assert(beginning_state != null, "STATE MACHINE: Beginning state not set.")
	
	_scan_states()
	_change_state(beginning_state.name)
	
func _input(event: InputEvent) -> void:
	if _current_state == null: return
	
	var next_state: State = _current_state.input_event(event)
	
	if is_instance_valid(next_state):
		change_state(next_state.name)
	
func _process(delta: float) -> void:
	if _current_state == null: return
	
	var next_state_frames: State = _current_state.frames(delta)
	var next_state_input: State = _current_state.input_process(delta)
	
	if is_instance_valid(next_state_input):
		change_state(next_state_input.name)
	elif is_instance_valid(next_state_frames):
		change_state(next_state_frames.name)
	
func _physics_process(delta: float) -> void:
	if _current_state == null: return
	
	var next_state: State = await _current_state.physics(delta)
	
	if is_instance_valid(next_state):
		change_state(next_state.name)
	
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
	var filtered_states: Array[State] = _states.filter(func(s): return s.name == state_name.strip_edges())
	assert(len(filtered_states) == 1, "STATE MACHINE: Could not pinpoint state with name '%s'. Found %d states." % [state_name, len(filtered_states)])
	
	return filtered_states.front() as State
	
## Invoked when [signal StateMachine.request_state_change] is emitted.
## Changes [member StateMachine.current_state] to a new state based on new state's node name.
## [br][br]
## Takes [String] [param new_state_name] for the name of the new state's node.
func _change_state(new_state_name: String) -> void:
	_changing_state = true
	
	var old_state_name: String = str(_current_state.name) if _current_state != null else ""
	var new_state: State = _find_state_by_name(new_state_name)
	
	if _current_state:
		_current_state.exit()
	_current_state = null
	
	new_state.enter()
	
	_current_state = new_state
	if old_state_name != new_state_name:
		state_changed.emit(old_state_name, new_state_name)
	
	_changing_state = false
	
## Changes this entity's state using its state machine
## Takes [String] [param new_state_name] for the name of the new state's node.
func change_state(new_state_name: String) -> void:
	if not can_change or _changing_state: return
	
	_change_state(new_state_name)

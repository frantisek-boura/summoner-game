@icon("res://addons/at-icons/node/arrow_axes_4d.svg")
class_name StateMachine
extends Node

@export var beginning_state: State

var states: Array[State] = []
var current_state: State = null
var changing_state: bool = false

signal request_state_change(state_name: String)

func _ready() -> void:
	assert(beginning_state != null, "STATE MACHINE: Beginning state not set.")
	
	request_state_change.connect(_change_state)
	
	_scan_states()
	_change_state(beginning_state.name)
	
func _input(event: InputEvent) -> void:
	if changing_state: return
	
	current_state.input_event(event)
	
func _process(delta: float) -> void:
	current_state.frames(delta)
	
	if changing_state: return
	
	current_state.input_process(delta)
	
func _physics_process(delta: float) -> void:
	if changing_state: return
	
	current_state.physics(delta)
	
## Filters this node's children for [State] nodes and saves them to [member StateMachine.states].
func _scan_states() -> void:
	for child in get_children():
		if child is State:
			states.append(child as State)
	
	assert(len(states) != 0, "STATE MACHINE: State machine has no states.")
	
## Finds state in [member StateMachine.states] by its node name.
## [br][br]
## Takes [String] [param state_name] for the name of the new state's node.
func _find_state_by_name(state_name: String) -> State:
	var filtered_states: Array[State] = states.filter(func(s): return s.name == state_name)
	assert(len(filtered_states) == 1, "STATE MACHINE: Could not pinpoint state with name '%s'. Found %d states." % [state_name, len(filtered_states)])
	
	return filtered_states.front() as State
	
## Invoked when [signal StateMachine.request_state_change] is emitted.
## Changes [member StateMachine.current_state] to a new state based on new state's node name.
## [br][br]
## Takes [String] [param state_name] for the name of the new state's node.
func _change_state(state_name: String) -> void:
	print("State change request: changing to %s" % state_name)
	changing_state = true
	
	var new_state: State = _find_state_by_name(state_name)
	
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
	
	changing_state = false

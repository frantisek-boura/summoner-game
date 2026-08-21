class_name Entity
extends CharacterBody2D

@export var state_machine: StateMachine
@export var movement: EntityMovement
# TODO: general health component

func _ready() -> void:
	assert(state_machine != null, "ENTITY: State machine not set.")
	assert(movement != null, "ENTITY: Movement not set.")

## Changes this entity's state using its state machine
## Takes [String] [param state_name] for the name of the new state's node.
func change_state(state_name: String) -> void:
	if state_machine.is_changing_states(): return
	
	state_machine.request_state_change.emit(state_name)

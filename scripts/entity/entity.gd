class_name Entity
extends CharacterBody2D

@export_range(10, 1000) var movement_speed: float = 10

@export var state_machine: StateMachine
# TODO: general health component

func _ready() -> void:
	assert(state_machine != null, "ENTITY: State machine not set, could not change state.")

func change_state(state_name: String) -> void:
	if state_machine.changing_state: return
	
	state_machine.request_state_change.emit(state_name)

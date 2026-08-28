@icon("res://addons/at-icons/node2d/human.svg")
class_name Entity
extends CharacterBody2D

@export var entity_state_machine: StateMachine
@export var entity_movement: EntityMovement
@export var entity_health: EntityHealth

func _ready() -> void:
	assert(entity_state_machine != null, "ENTITY: State machine not set.")
	assert(entity_movement != null, "ENTITY: Movement not set.")
	assert(entity_health != null, "ENTITY: Health not set.")

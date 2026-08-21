@icon("res://addons/at-icons/node2d/human.svg")
class_name Entity
extends CharacterBody2D

@export var state_machine: StateMachine
@export var movement: EntityMovement
@export var health: EntityHealth

func _ready() -> void:
	assert(state_machine != null, "ENTITY: State machine not set.")
	assert(movement != null, "ENTITY: Movement not set.")
	assert(health != null, "ENTITY: Health not set.")

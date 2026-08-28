@icon("res://addons/at-icons/node2d/person_body.svg")
class_name Minion
extends Entity

@onready var movement: MinionMovement = entity_movement as MinionMovement
@onready var state_machine: MinionStateMachine = entity_state_machine as MinionStateMachine
@onready var health: EntityHealth = entity_health as EntityHealth

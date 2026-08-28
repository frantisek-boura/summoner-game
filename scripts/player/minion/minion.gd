@icon("res://addons/at-icons/node2d/person_body.svg")
class_name Minion
extends Entity

var movement: MinionMovement
var state_machine: MinionStateMachine
var health: EntityHealth

func _enter_tree() -> void:
	movement = entity_movement as MinionMovement
	state_machine = entity_state_machine as MinionStateMachine
	health = entity_health as EntityHealth

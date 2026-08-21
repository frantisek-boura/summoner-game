@icon("res://addons/at-icons/node2d/person_body.svg")
class_name Minion
extends Entity

@onready var minion_manager: MinionManager = get_parent() as MinionManager

var index: int = 0

var minion_movement: MinionMovement:
	get:
		return movement as MinionMovement
var minion_state_machine: MinionStateMachine:
	get: 
		return state_machine as MinionStateMachine

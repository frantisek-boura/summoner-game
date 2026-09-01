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

func force_to_follow_state() -> void:
	state_machine.change_state_safe("minion_follow_state")
	
func force_to_select_state() -> void:
	state_machine.change_state_safe("minion_select_state")

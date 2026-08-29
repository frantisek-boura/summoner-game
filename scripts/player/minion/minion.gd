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

func stop() -> void:
	movement.stop()

func has_arrived_to_follow_position() -> bool:
	return movement.has_arrived(movement.follow_position)

func follow_path() -> void:
	movement.follow_path()

func set_follow_path(follow_position: Vector2) -> void:
	movement.follow_position = follow_position

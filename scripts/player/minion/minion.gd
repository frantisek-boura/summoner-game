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

func force_to_follow_state() -> void:
	state_machine.change_state_safe("minion_follow_state")
	
func force_to_select_state() -> void:
	state_machine.change_state_safe("minion_select_state")

func has_arrived_to_select_position() -> bool:
	return movement.has_arrived(movement._select_position)

func has_arrived_to_follow_position() -> bool:
	return movement.has_arrived(movement._follow_position)

func follow_path() -> void:
	movement.follow_path()

func set_select_position(angle: float, entity_position: Vector2, forcible_minions_count: int, forcible_minion_index: int) -> void:
	movement.set_select_position(angle, entity_position, forcible_minions_count, forcible_minion_index)

func set_follow_path(follow_position: Vector2) -> void:
	movement.set_follow_position(follow_position)

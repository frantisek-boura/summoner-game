@icon("res://addons/at-icons/node/arrow_cross.svg")
class_name PlayerMovement
extends EntityMovement

## Returns player's omnidirectional input direction
func _get_input_direction() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

## Queries for player's input direction and saves it using [Movement] component.
func handle_movement_input() -> void:
	var new_direction: Vector2 = _get_input_direction()
	change_direction(new_direction)

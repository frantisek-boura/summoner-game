@icon("res://addons/at-icons/node/arrow_cross.svg")
class_name PlayerMovement
extends EntityMovement

## Returns player's omnidirectional input direction
func get_input_direction() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

class_name Player
extends Entity
	
## Returns player's omnidirectional input direction
func get_input_direction() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

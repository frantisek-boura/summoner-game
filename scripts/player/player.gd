class_name Player
extends Entity

var direction: Vector2 = Vector2.ZERO

func get_movement_input_direction() -> void:
	direction = Input.get_vector("left", "right", "up", "down")

func is_moving() -> bool:
	return direction != Vector2.ZERO
	
func move() -> void:
	velocity = direction * movement_speed
	move_and_slide()

func reset_velocity() -> void:
	velocity = Vector2.ZERO

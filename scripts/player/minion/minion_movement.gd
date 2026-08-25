class_name MinionMovement
extends EntityMovement

@export_range(10, 1000, 1) var idle_radius: float = 10
@export_range(1, 20, 1) var idle_acceleration_speed: float = 10
@export_range(1, 20, 1) var lock_in_acceleration_speed: float = 10
@export_range(10, 1000, 1) var follow_movement_speed: float = 10
@export_range(10, 1000, 1) var follow_acceleration_speed: float = 10

var minion: Minion:
	get:
		return _entity as Minion

## Calculates the current idling position of this minion.
func get_idle_position() -> Vector2:
	var center_position: Vector2 = minion.minion_manager.entity.global_position
	var offset: float = minion.minion_manager.minion_offset(minion.index)
	
	var idle_position: Vector2 = center_position + Vector2(sin(minion.minion_manager.angle + offset), cos(minion.minion_manager.angle + offset) * 0.5) * idle_radius
	
	return idle_position
	
## Moves this minion towards the idling position.
## Takes [Vector2] [param new_position] as the position the minion will be locked in.
func idle_around(delta: float, idle_position: Vector2) -> void:
	_direction = minion.global_position.direction_to(idle_position)
	
	minion.global_position = minion.global_position.lerp(idle_position, delta * idle_acceleration_speed)
	
	minion.move_and_slide()
	
## Locks the minion in a given position.
## Takes [Vector2] [param new_position] as the position the minion will be locked in.
func lock_in_position(delta: float, new_position: Vector2) -> void:
	_direction = minion.global_position.direction_to(new_position)
	
	minion.global_position = minion.global_position.lerp(new_position, delta * lock_in_acceleration_speed)
	
	minion.move_and_slide()
	
## Moves this minion towards the owner entity's position.
func follow_path(delta: float) -> void:
	var point_position: Vector2 = minion.minion_manager.minion_path.get_follow_position(minion.index)
	_direction = minion.global_position.direction_to(point_position)
	
	#minion.global_position = minion.global_position.lerp(entity_position, delta * follow_acceleration_speed)
	minion.velocity.x = move_toward(minion.velocity.x, _direction.x * follow_movement_speed, follow_acceleration_speed)
	minion.velocity.y = move_toward(minion.velocity.y, _direction.y * follow_movement_speed, follow_acceleration_speed)
	
	minion.move_and_slide()

## Resets this minion's direction.
func reset_direction() -> void:
	_direction = Vector2.ZERO
	
## Teleports minion to a new position.
## Takes [Vector2] [param new_position] for the new position.
func set_to_position(new_position: Vector2) -> void:
	minion.global_position = new_position

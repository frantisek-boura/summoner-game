class_name MinionMovement
extends EntityMovement

@export_range(10, 1000, 1) var idle_radius: float = 10
@export_range(10, 10000, 1) var idle_movement_speed: float = 10
@export_range(10, 100, 1) var idle_acceleration_speed: float = 1000
@export_range(10, 10000, 1) var follow_movement_speed: float = 10
@export_range(10, 100, 1) var follow_acceleration_speed: float = 1000

var minion: Minion:
	get:
		return _entity as Minion

func get_entity_position() -> Vector2:
	return minion.minion_manager.entity.global_position

func get_idle_position() -> Vector2:
	var idle_position: Vector2 = minion.minion_manager.entity.global_position
	var offset: float = minion.minion_manager.minion_offset(minion.index)
	
	idle_position.x += sin(minion.minion_manager.angle + offset) * idle_radius
	idle_position.y += cos(minion.minion_manager.angle + offset) * idle_radius
	
	return idle_position
	
func move_to_idle() -> void:
	minion.velocity.x = move_toward(minion.velocity.x, _direction.x * idle_movement_speed, idle_acceleration_speed)
	minion.velocity.y = move_toward(minion.velocity.y, _direction.y * idle_movement_speed, idle_acceleration_speed)
	
	minion.move_and_slide()

func move_to_entity() -> void:
	minion.velocity.x = move_toward(minion.velocity.x, _direction.x * follow_movement_speed, follow_acceleration_speed)
	minion.velocity.y = move_toward(minion.velocity.y, _direction.y * follow_movement_speed, follow_acceleration_speed)
	
	minion.move_and_slide()

func reset_direction() -> void:
	_direction = Vector2.ZERO

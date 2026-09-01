class_name MinionMovement
extends EntityMovement

@export_range(1, 20, 1) var select_acceleration_speed: float = 10
@export_range(1, 20, 1) var lock_in_acceleration_speed: float = 10
@export_range(10, 1000, 1) var follow_movement_speed: float = 10
@export_range(10, 1000, 1) var follow_acceleration_speed: float = 10

var minion: Minion:
	get: 
		return _entity as Minion
var _follow_position: Vector2
var _select_position: Vector2

## Used to define this minion's [member MinionMovement._follow_position]. 
## Should be used by [MinionManager].
func set_follow_position(follow_position: Vector2) -> void:
	_follow_position = follow_position

## Calculates the idle position based on [member MinionManager.angle], [member MinionManager.entity]'s global_position, the amount of
## forcible minions defined by the length of [member MinionHandler.forcible_minions], and this minion's forcible index defined by key-value pairs in [member MinionHandler.forcible_minions],
## where this minion's [Minion] instance is the key and the index is the value.
## Should be used by [MinionManager]
func set_select_position(angle: float, entity_position: Vector2, forcible_minions_count: int, forcible_minion_index: int) -> void:
	var offset = (TAU / forcible_minions_count) * forcible_minion_index
	var select_position: Vector2 = entity_position + Vector2(
			sin(angle + offset), 
			cos(angle + offset) * MinionManager.IDLE_RADIUS_Y_MULTIPLIER
		) * MinionManager.IDLE_RADIUS
	_select_position = select_position

## Moves this minion towards the idling position.
## Takes [Vector2] [param new_position] as the position the minion will be locked in.
func move_select(delta: float) -> void:
	_direction = minion.global_position.direction_to(_select_position)
	
	minion.global_position = minion.global_position.lerp(_select_position, delta * select_acceleration_speed)
	
	minion.move_and_slide()

## Checks if this minion has arrived to [member MinionMovement._select_position]
func has_arrived_select() -> bool:
	return has_arrived(_select_position)

## Moves this minion towards the owner entity's position.
func move_follow() -> void:
	_direction = minion.global_position.direction_to(_follow_position)
	
	minion.velocity.x = move_toward(minion.velocity.x, _direction.x * follow_movement_speed, follow_acceleration_speed)
	minion.velocity.y = move_toward(minion.velocity.y, _direction.y * follow_movement_speed, follow_acceleration_speed)
	
	minion.move_and_slide()
	
## Checks if this minion has arrived to [member MinionMovement._follow_position]
func has_arrived_follow() -> bool:
	return has_arrived(_follow_position)
	
#func set_in_position(new_position: Vector2) -> void:
	#_direction = minion.global_position.direction_to(new_position)
	#
	#minion.global_position = new_position
	#
	#minion.move_and_slide()
	#
### Locks the minion in a given position.
### Takes [Vector2] [param new_position] as the position the minion will be locked in.
#func lock_in_position(delta: float, new_position: Vector2) -> void:
	#_direction = minion.global_position.direction_to(new_position)
	#
	#minion.global_position = minion.global_position.lerp(new_position, delta * lock_in_acceleration_speed)
	#
	#minion.move_and_slide()
	

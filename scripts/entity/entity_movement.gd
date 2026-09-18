@icon("res://addons/at-icons/node/arrow_cross.svg")
class_name EntityMovement
extends Node

const HAS_ARRIVED_DETECTION_RADIUS: float = 5.0

@export_range(10, 1000, 1) var movement_speed: float = 250.0
@export_range(10, 100, 1) var move_acceleration_speed: float = 50.0
@export_range(10, 100, 1) var stop_acceleration_speed: float = 50.0

@onready var _entity: Entity = get_parent() as Entity

var target_position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var can_move: bool = true

## Generic request signal for target position, inheriting classes should implement their own signal
## for their own specific needs.
signal _request_target_position(entity: Entity)
signal target_position_received
	
## Accelerates the entity based on its current direction value set by [method EntityMovement.change_direction].
func move() -> void:
	slide_toward(movement_speed, stop_acceleration_speed)

## Decelerates the entity to [enum Vector2.ZERO].
func stop() -> void:
	slide_toward(0, stop_acceleration_speed)

## Lerps entity toward [Vector2] [param position] with [float] [param weight].
## Changes the direction this entity is heading.
func lerp_toward(weight: float) -> void:
	if not can_move: return
	
	_entity.global_position = _entity.global_position.lerp(target_position, weight)
	
	_entity.move_and_slide()

## Moves entity in direction set by [method EntityMovement.change_direction] at [float] [param speed]
## with [float] [param acceleration]. Call [method EntityMovmenet.change_direction] before using slide_toward.
func slide_toward(speed: float, acceleration: float) -> void:
	if not can_move: return
	
	_entity.velocity.x = move_toward(_entity.velocity.x, direction.x * speed, acceleration)
	_entity.velocity.y = move_toward(_entity.velocity.y, direction.y * speed, acceleration)
	
	_entity.move_and_slide()

## Changes the direction entity is moving in.
## Takes [Vector2] [param new_direction] for new movement direction.
func change_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

## Changed the target direction entity is moving towards.
## Takes [Vector2] [param new_position] for new target position.
func change_target_position(new_position: Vector2) -> void:
	target_position = new_position

## Checks if the entity has arrived to a [Vector2] destination.
## Takes [Vector2] [param destination] for the position of the destination.
func has_arrived() -> bool:
	return _entity.position.distance_to(target_position) < HAS_ARRIVED_DETECTION_RADIUS

## Checks if the entity is moving based on its current direction value set by [method EntityMovement.change_direction].
func wants_to_move() -> bool:
	return direction != Vector2.ZERO
	
## Checks whether this entity is physically moving.
func is_moving() -> bool:
	return _entity.velocity != Vector2.ZERO

## Checks for entity's movement.
func check_movement() -> bool:
	return wants_to_move() and can_move
	
## Resets this entity's velocity.
func reset_velocity() -> void:
	_entity.velocity = Vector2.ZERO
	
## Resets this entity's direction.
func reset_direction() -> void:
	direction = Vector2.ZERO

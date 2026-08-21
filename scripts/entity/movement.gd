@icon("res://addons/at-icons/node/arrow_cross.svg")
class_name EntityMovement
extends Node

@export_range(10, 1000, 1) var movement_speed: float = 250.0
@export_range(10, 100, 1) var move_acceleration_speed: float = 50.0
@export_range(10, 100, 1) var stop_acceleration_speed: float = 50.0

@onready var _entity: Entity = get_parent() as Entity

var _direction: Vector2 = Vector2.ZERO
var _can_move: bool = true

func _ready() -> void:
	assert(_entity != null, "ENTITY MOVEMENT: Entity is not set.")
	
## Moves the entity based on its current direction value set by [method EntityMovement.change_direction].
func move() -> void:
	if not _can_move: return
	
	_entity.velocity.x = move_toward(_entity.velocity.x, _direction.x * movement_speed, move_acceleration_speed)
	_entity.velocity.y = move_toward(_entity.velocity.y, _direction.y * movement_speed, move_acceleration_speed)
	
	_entity.move_and_slide()

func stop() -> void:
	if not _can_move: return
	
	_entity.velocity.x = move_toward(_entity.velocity.x, 0, stop_acceleration_speed)
	_entity.velocity.y = move_toward(_entity.velocity.y, 0, stop_acceleration_speed)
	
	_entity.move_and_slide()

## Changes the direction entity is moving in.
## Takes [Vector2] [param new_direction] for new movement direction.
func change_direction(new_direction: Vector2) -> void:
	_direction = new_direction

## Checks if the entity has arrived to a [Vector2] destination.
## Takes [Vector2] [param destination] for the position of the destination.
func has_arrived(destination: Vector2) -> bool:
	return _entity.position.distance_to(destination) < 0.1

## Checks if the entity is moving based on its current direction value set by [method EntityMovement.change_direction].
func wants_to_move() -> bool:
	return _direction != Vector2.ZERO
	
## Checks whether this entity is moving intentionally (moving with player input)
func is_moving() -> bool:
	return _entity.velocity != Vector2.ZERO and _direction != Vector2.ZERO

## Decides whether this entity can or cannot move.
## Takes [bool] [param is_enabled] to decide.
func enable_movement(is_enabled: bool) -> void:
	_can_move = is_enabled
	
## Checks whether this entity can or cannot move.
func can_move() -> bool:
	return _can_move

## Resets entity's velocity back to [member Vector2.ZERO]
func reset_velocity() -> void:
	_entity.velocity = Vector2.ZERO

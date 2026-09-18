class_name MinionMovement
extends EntityMovement

@export_range(0.1, 1.0, 0.01) var select_lerp_weight: float = 0.5
@export_range(0.1, 1.0, 0.01) var follow_lerp_weight: float = 0.5
@export_range(0.1, 1.0, 0.01) var owner_lerp_weight: float = 0.5
@export_range(10, 1000, 1) var select_movement_speed: float = 100
@export_range(10, 1000, 1) var select_acceleration_speed: float = 100

var minion: Minion:
	get: 
		return _entity as Minion

signal request_follow_position(requesting_minion: Minion)
signal request_owner_position(requesting_minion: Minion)
signal request_select_position(requesting_minion: Minion)
signal in_owner_position
signal in_select_position

## Used to define this minion's [member MinionMovement._follow_position]. 
## Should be used by [MinionManager].
func set_follow_position(follow_position: Vector2) -> void:
	super.change_target_position(follow_position)
	target_position_received.emit()

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
	super.change_target_position(select_position) 
	target_position_received.emit()
	
## Used to define the minion's owner's position. Is used by function [method MinionMovement.move_owner]
## to move the minion towards [param owner_position].
func set_owner_position(owner_position: Vector2) -> void:
	super.change_target_position(owner_position)
	target_position_received.emit()

## Moves this minion towards the owner entity's position.
func lerp_follow() -> void:
	super.lerp_toward(follow_lerp_weight)

## Slides this minion in its direction defined by [method EntityMovement.change_direction]
func slide_select() -> void:
	super.slide_toward(select_movement_speed, select_acceleration_speed)
	
## Moves this minion towards the selecting position. Uses position lerp.
func lerp_select() -> void:
	super.lerp_toward(select_lerp_weight)

## Moves this minion towards the [Vector2] [param target_position].
func lerp_owner() -> void:
	super.lerp_toward(owner_lerp_weight)

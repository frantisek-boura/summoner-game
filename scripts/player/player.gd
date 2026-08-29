class_name Player
extends Entity

@export var camera: PlayerCamera
@export var minion_manager: MinionManager

@onready var movement: PlayerMovement = entity_movement as PlayerMovement
@onready var state_machine: StateMachine = entity_state_machine as StateMachine
@onready var health: EntityHealth = entity_health as EntityHealth

func enable_path_updates() -> void:
	minion_manager.enable_path_updates()
	
func disable_path_updates() -> void:
	minion_manager.disable_path_updates()

func minion_manager_follow() -> void:
	minion_manager.change_to_follow_state()
	
func minion_manager_select() -> void:
	minion_manager.change_to_select_state()

## Moves the player using its [member Player.movement] component.
func move_with_input() -> void:
	movement.move()

## Stops the player using its [member Player.movement] component.
func stop() -> void:
	movement.stop()

## Queries for player's movement direction using its [member Player.movement] component.
func handle_movement_input() -> void:
	var new_direction: Vector2 = movement.get_input_direction()
	movement.change_direction(new_direction)

## Checks for player's movement input [member Player.movement] component.
func check_movement() -> bool:
	return movement.wants_to_move() and movement.can_move()

## Changes the player's state to move using its [member Player.state_machine] component.
func change_to_move_state() -> void:
	state_machine.change_state("player_move_state")

## Changes the player's state to idle using its [member Player.state_machine] component.
func change_to_idle_state() -> void:
	state_machine.change_state("player_idle_state")
	

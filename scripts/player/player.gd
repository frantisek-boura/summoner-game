class_name Player
extends Entity

@export var camera: PlayerCamera
@export var minion_manager: MinionManager

@onready var movement: PlayerMovement = entity_movement as PlayerMovement
@onready var state_machine: StateMachine = entity_state_machine as StateMachine
@onready var health: EntityHealth = entity_health as EntityHealth

func stop() -> void:
	movement.stop()

func handle_movement_input() -> void:
	var new_direction: Vector2 = movement.get_input_direction()
	movement.change_direction(new_direction)

func check_movement() -> bool:
	return movement.wants_to_move() and movement.can_move()

func change_to_move_state() -> void:
	state_machine.change_state("player_move_state")

func change_to_idle_state() -> void:
	state_machine.change_state("player_idle_state")
	
func move_with_input() -> void:
	movement.move()

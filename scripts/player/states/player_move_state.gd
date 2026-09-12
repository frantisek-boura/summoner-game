class_name PlayerMoveState
extends State

@export var idle_state: State

@export var player: Player

func _ready() -> void:
	assert(player != null, "PLAYER MOVE STATE: Stateful node not set")
	assert(idle_state != null, "PLAYER MOVE STATE: PlayerIdleState node not set")

func enter() -> void:
	player.minion_manager.enable_path_updates()

func exit() -> void:
	player.minion_manager.disable_path_updates()

func frames(_delta: float) -> State:
	return null

func physics(_delta: float) -> State:
	player.movement.move()
	
	return null

func input_process(_delta: float) -> State:
	player.movement.handle_movement_input()
	
	if not player.movement.check_movement():
		return idle_state
	
	return null

func input_event(event: InputEvent) -> State:
	if event.is_action_pressed("escape"):
		player.minion_manager.add_default_minion()
	
	return null

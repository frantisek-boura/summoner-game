class_name PlayerIdleState
extends State

@export var move_state: PlayerMoveState

@export var player: Player

func _ready() -> void:
	assert(player != null, "PLAYER IDLE STATE: Stateful node not set")
	assert(move_state != null, "PLAYER IDLE STATE: PlayerMoveState node not set")

func enter() -> void:
	if player.minion_manager.is_selecting():
		player.minion_manager.close_selection_menu(false)
		player.minion_manager.change_to_follow_state()

func exit() -> void:
	if player.minion_manager.is_selecting():
		player.minion_manager.close_selection_menu(false)
		player.minion_manager.change_to_follow_state()

func frames(_delta: float) -> State:
	return null

func physics(_delta: float) -> State:
	player.movement.stop()
	
	return null

func input_process(_delta: float) -> State:
	player.movement.handle_movement_input()
	
	if player.movement.check_movement():
		return move_state
		
	return null

func input_event(event: InputEvent) -> State:
	if event.is_action_pressed("minion_selector") and not player.minion_manager.is_selecting():
		player.minion_manager.change_to_select_state()
	if event.is_action_released("minion_selector") and player.minion_manager.is_selecting():
		player.minion_manager.close_selection_menu(true)
		player.minion_manager.change_to_follow_state()
	if event.is_action_pressed("escape"):
		player.minion_manager.add_default_minion()
	
	return null

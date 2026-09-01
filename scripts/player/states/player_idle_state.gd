class_name PlayerIdleState
extends State

@export var player: Player

func _ready() -> void:
	assert(player != null, "PLAYER IDLE STATE: Stateful node not set")

func enter() -> void:
	player.minion_manager.change_to_follow_state()

func exit() -> void:
	if player.minion_manager.is_selecting():
		player.camera.zoom_to_default()
		player.minion_manager.close_selection_menu(false)
		player.minion_manager.change_to_follow_state()

func frames(_delta: float) -> void:
	pass

func physics(_delta: float) -> void:
	player.movement.stop()

func input_process(_delta: float) -> void:
	player.movement.handle_movement_input()
	
	if player.movement.check_movement():
		player.state_machine.change_state("player_move_state")
		

func input_event(event: InputEvent) -> void:
	pass
	if event.is_action_pressed("minion_selector") and not player.minion_manager.is_selecting():
		player.camera.zoom_to_select()
		player.minion_manager.open_selection_menu()
		player.minion_manager.change_to_select_state()
	if event.is_action_released("minion_selector") and player.minion_manager.is_selecting():
		player.camera.zoom_to_default()
		player.minion_manager.close_selection_menu(true)
		player.minion_manager.change_to_follow_state()
	if event.is_action_pressed("escape"):
		player.minion_manager.add_default_minion()

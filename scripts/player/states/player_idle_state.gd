class_name PlayerIdleState
extends State

@export var player: Player

func _ready() -> void:
	assert(player != null, "PLAYER IDLE STATE: Stateful node not set")

func enter() -> void:
	pass

func exit() -> void:
	if player.minion_manager.is_idling:
		player.minion_manager.follow_minions()
		player.camera.zoom_to_default()

func frames(_delta: float) -> void:
	pass

func physics(_delta: float) -> void:
	player.player_movement.stop()

func input_process(_delta: float) -> void:
	var new_direction: Vector2 = player.player_movement.get_input_direction()
	player.player_movement.change_direction(new_direction)
	
	if player.player_movement.wants_to_move() and player.player_movement.can_move():
		player.state_machine.change_state("player_move_state")

func input_event(event: InputEvent) -> void:
	if event.is_action_pressed("minion_selector") and not player.minion_manager.is_idling:
		player.minion_manager.idle_minions()
		player.camera.zoom_to_idle()
	if event.is_action_released("minion_selector") and player.minion_manager.is_idling:
		player.minion_manager.radial_minion_menu.make_selection()
		player.minion_manager.follow_minions()
		player.camera.zoom_to_default()
	if event.is_action_released("escape") and player.minion_manager.is_idling:
		player.minion_manager.follow_minions()
		player.camera.zoom_to_default()
	if event.is_action_pressed("set_selected_minion_independent"):
		player.minion_manager.set_minion_independent("minion_still_state")

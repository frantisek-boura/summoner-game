class_name PlayerIdleState
extends State

@export var player: Player

func _ready() -> void:
	assert(player != null, "PLAYER IDLE STATE: Stateful node not set")

func enter() -> void:
	pass

func exit() -> void:
	pass
	#if player.minion_manager.is_idling:
		#player.minion_manager.follow_minions()
		#player.camera.zoom_to_default()

func frames(_delta: float) -> void:
	pass

func physics(_delta: float) -> void:
	player.stop()

func input_process(_delta: float) -> void:
	player.handle_movement_input()
	
	if player.check_movement():
		player.change_to_move_state()
		

func input_event(event: InputEvent) -> void:
	pass
	#if event.is_action_pressed("minion_selector") and not player.minion_manager.is_idling:
		#player.minion_manager.idle_minions()
		#player.camera.zoom_to_idle()
	#if event.is_action_released("minion_selector") and player.minion_manager.is_idling:
		#player.minion_manager.radial_minion_menu.make_selection()
		#player.minion_manager.follow_minions()
		#player.camera.zoom_to_default()
	#if event.is_action_released("escape") and player.minion_manager.is_idling:
		#player.minion_manager.follow_minions()
		#player.camera.zoom_to_default()
	#if event.is_action_pressed("set_selected_minion_independent"):
		#player.minion_manager.set_minion_independent("minion_still_state")

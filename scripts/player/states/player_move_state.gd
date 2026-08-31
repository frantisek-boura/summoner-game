class_name PlayerMoveState
extends State

@export var player: Player

func _ready() -> void:
	assert(player != null, "PLAYER MOVE STATE: Stateful node not set")

func enter() -> void:
	player.enable_path_updates()

func exit() -> void:
	player.disable_path_updates()

func frames(_delta: float) -> void:
	pass

func physics(_delta: float) -> void:
	player.move_with_input()

func input_process(_delta: float) -> void:
	player.handle_movement_input()
	
	if not player.check_movement():
		player.change_to_idle_state()

func input_event(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		player.minion_manager.add_default_minion()

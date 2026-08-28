class_name PlayerMoveState
extends State

@export var player: Player

func _ready() -> void:
	assert(player != null, "PLAYER MOVE STATE: Stateful node not set")

func enter() -> void:
	pass
	#player.minion_manager.minion_path.enable_updates()

func exit() -> void:
	pass
	#player.minion_manager.minion_path.disable_updates()

func frames(_delta: float) -> void:
	pass

func physics(_delta: float) -> void:
	player.move_with_input()

func input_process(_delta: float) -> void:
	player.handle_movement_input()
	
	if not player.check_movement():
		player.change_to_idle_state()

func input_event(_event: InputEvent) -> void:
	pass

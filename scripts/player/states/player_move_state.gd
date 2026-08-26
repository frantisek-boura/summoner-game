class_name PlayerMoveState
extends State

@export var player: Player

func _ready() -> void:
	assert(player != null, "PLAYER MOVE STATE: Stateful node not set")

func enter() -> void:
	player.minion_manager.minion_path.enable_updates()

func exit() -> void:
	player.minion_manager.minion_path.disable_updates()

func frames(_delta: float) -> void:
	pass

func physics(_delta: float) -> void:
	player.player_movement.move()

func input_process(_delta: float) -> void:
	var new_direction: Vector2 = player.player_movement.get_input_direction()
	player.player_movement.change_direction(new_direction)
	
	if not player.player_movement.wants_to_move() or not player.player_movement.can_move():
		player.state_machine.change_state("player_idle_state")

func input_event(_event: InputEvent) -> void:
	pass

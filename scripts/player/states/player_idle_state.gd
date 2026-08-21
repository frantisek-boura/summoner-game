class_name PlayerIdleState
extends State

@export var player: Player

func _ready() -> void:
	assert(player != null, "PLAYER IDLE STATE: Stateful node not set")

func enter() -> void:
	player.minion_manager.state_machine.change_state("minion_manager_idle_state")

func exit() -> void:
	pass

func frames(_delta: float) -> void:
	pass

func physics(_delta: float) -> void:
	player.player_movement.stop()

func input_process(_delta: float) -> void:
	var new_direction: Vector2 = player.player_movement.get_input_direction()
	player.player_movement.change_direction(new_direction)

	if player.player_movement.wants_to_move() and player.player_movement.can_move():
		player.state_machine.change_state("player_move_state")

func input_event(_event: InputEvent) -> void:
	pass

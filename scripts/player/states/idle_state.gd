class_name PlayerIdleState
extends State

@export var player: Player

func _ready() -> void:
	assert(player != null, "PLAYER IDLE STATE: Stateful node not set")

func enter() -> void:
	pass

func exit() -> void:
	pass

func frames(_delta: float) -> void:
	pass

func physics(_delta: float) -> void:
	player.movement.stop()

func input_process(_delta: float) -> void:
	var new_direction: Vector2 = player.get_input_direction()
	player.movement.change_direction(new_direction)

	if player.movement.wants_to_move() and player.movement.can_move():
		player.change_state("move_state")

func input_event(_event: InputEvent) -> void:
	pass

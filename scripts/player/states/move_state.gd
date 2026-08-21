class_name PlayerMoveState
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
	player.movement.move()

func input_process(_delta: float) -> void:
	var new_direction: Vector2 = player.get_input_direction()
	player.movement.change_direction(new_direction)
	
	if not player.movement.wants_to_move() or not player.movement.can_move():
		player.change_state("idle_state")

func input_event(_event: InputEvent) -> void:
	pass

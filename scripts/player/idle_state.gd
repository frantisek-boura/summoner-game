class_name PlayerIdleState
extends State

@export var stateful_node: Player

func _ready() -> void:
	assert(stateful_node != null, "PLAYER IDLE STATE: Stateful node not set")

func enter() -> void:
	stateful_node.reset_velocity()

func exit() -> void:
	pass

func frames(delta: float) -> void:
	pass

func physics(delta: float) -> void:
	pass

func input_process(delta: float) -> void:
	stateful_node.get_movement_input_direction()

	if stateful_node.is_moving(): 
		stateful_node.change_state("move_state")

func input_event(event: InputEvent) -> void:
	pass

class_name MinionIdleState
extends State

@export var minion: Minion

func _ready() -> void:
	assert(minion != null, "MINION IDLE STATE: Stateful node not set")

func enter() -> void:
	minion.movement.reset_velocity()

func exit() -> void:
	pass

func frames(_delta: float) -> State:
	return null

func physics(delta: float) -> State:
	minion.movement.move_select(delta)
	
	return null

func input_process(_delta: float) -> State:
	return null

func input_event(_event: InputEvent) -> State:
	return null

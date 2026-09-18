class_name MinionSelectState3
extends State

@export var minion: Minion

func _ready() -> void:
	assert(minion != null, "MINION SELECT STATE: Stateful node not set")

func enter() -> void:
	minion.movement.reset_velocity()
	minion.movement.in_select_position.emit()

func exit() -> void:
	pass

func frames(_delta: float) -> State:
	return null

func physics(_delta: float) -> State:
	minion.movement.lerp_select()
	
	return null

func input_process(_delta: float) -> State:
	return null

func input_event(_event: InputEvent) -> State:
	return null

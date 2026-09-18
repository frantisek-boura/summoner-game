class_name MinionFollowState
extends State

@export var minion: Minion

func _ready() -> void:
	assert(minion != null, "MINION FOLLOW STATE: Stateful node not set")

func enter() -> void:
	pass

func exit() -> void:
	pass

func frames(_delta: float) -> State:
	return null

func physics(_delta: float) -> State:
	if minion.movement.has_arrived():
		minion.movement.stop()
	else:
		minion.movement.lerp_follow()
		
	return null

func input_process(_delta: float) -> State:
	return null

func input_event(_event: InputEvent) -> State:
	return null

class_name MinionFollowState
extends State

@export var minion: Minion

func _ready() -> void:
	assert(minion != null, "MINION FOLLOW STATE: Stateful node not set")

func enter() -> void:
	pass

func exit() -> void:
	pass

func frames(_delta: float) -> void:
	pass

func physics(_delta: float) -> void:
	if minion.movement.has_arrived_follow():
		minion.movement.stop()
	else:
		minion.movement.move_follow()

func input_process(_delta: float) -> void:
	pass

func input_event(_event: InputEvent) -> void:
	pass

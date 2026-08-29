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
	if minion.has_arrived_to_follow_position():
		minion.stop()
	else:
		minion.follow_path()

func input_process(_delta: float) -> void:
	pass

func input_event(_event: InputEvent) -> void:
	pass

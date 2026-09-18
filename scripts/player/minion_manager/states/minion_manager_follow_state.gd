class_name MinionManagerFollowState
extends State

@export var minion_manager: MinionManager

func _ready() -> void:
	assert(minion_manager != null, "MINION MANAGER FOLLOW STATE: Stateful node not set")

func enter() -> void:
	minion_manager.update_minion_follow_points()
	minion_manager.force_minions_follow()

func exit() -> void:
	pass

func frames(_delta: float) -> State:
	return null

func physics(_delta: float) -> State:
	return null

func input_process(_delta: float) -> State:
	return null

func input_event(_event: InputEvent) -> State:
	return null

class_name MinionManagerSelectState
extends State

@export var minion_manager: MinionManager

func _ready() -> void:
	assert(minion_manager != null, "MINION MANAGER IDLE STATE: Stateful node not set")

func enter() -> void:
	minion_manager.force_minions_select()
	
func exit() -> void:
	pass

func frames(_delta: float) -> State:
	return null

func physics(delta: float) -> State:
	minion_manager.inc_angle(delta)
	minion_manager.update_minion_select_positions()
	
	return null

func input_process(_delta: float) -> State:
	return null

func input_event(_event: InputEvent) -> State:
	return null

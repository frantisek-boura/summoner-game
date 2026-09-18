class_name MinionManagerSelectState
extends State

@export var minion_manager: MinionManager

var _selection_ready: bool = false

func _ready() -> void:
	assert(minion_manager != null, "MINION MANAGER IDLE STATE: Stateful node not set")
	
	minion_manager.selection_ready.connect(_on_selection_ready)

func enter() -> void:
	_selection_ready = false
	minion_manager.force_minions_select()
	
func exit() -> void:
	pass

func frames(_delta: float) -> State:
	return null

func physics(delta: float) -> State:
	if not _selection_ready: return
	
	minion_manager.inc_angle(delta)
	minion_manager.update_minion_select_positions()
	
	return null

func input_process(_delta: float) -> State:
	return null

func input_event(_event: InputEvent) -> State:
	return null
	
func _on_selection_ready() -> void:
	_selection_ready = true

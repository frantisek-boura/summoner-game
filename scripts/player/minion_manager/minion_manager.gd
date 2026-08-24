@icon("res://addons/at-icons/node2d/brain.svg")
class_name MinionManager
extends Node

@export var state_machine: MinionManagerStateMachine
@export_range(1, 20) var idle_rotation_speed: float = 0.5

@onready var entity: Entity = get_parent() as Entity

var _minions: Array[Minion] = []
var _minion_count: int = 0
var _ready_minions: Array[int] = []
var angle: float = 0

func _ready() -> void:
	assert(state_machine != null, "MINION MANAGER: State Machine not set.")
	assert(entity != null, "MINION MANAGER: Entity not set.")
	
	child_entered_tree.connect(_scan_minions.bind(false))
	child_exiting_tree.connect(_scan_minions.bind(true))
	
	_scan_minions(null, false)

## Scans child nodes for minions and adds them to [member MinionManager._minions].
## Is invoked on _ready and whenever a node enters/leaves child tree of [MinionManager]
func _scan_minions(node: Node, is_deleting: bool) -> void:
	var new_minions: Array[Minion] = []
	var count: int = 0
	
	for child in get_children():
		if child is Minion:
			if child == node and is_deleting: continue
			count += 1
			child.index = count
			new_minions.append(child)
	
	_minion_count = count
	_minions = new_minions
	
## Filters [member MinionManager._members] for those, that can be forced to change state.
func _get_forceable_minions() -> Array[Minion]:
	return _minions.filter(func(m: Minion): return m.minion_state_machine.is_forceable())
	
## Returns the radial offset by minion index in rads.
func minion_offset(index: int) -> float:
	return (TAU / _minion_count) * index
	
## Increases internal [member MinionManager.angle] value used for determining current idle position of each minion.
## Takes [float] [param delta] as increment.
func inc_angle(delta: float) -> void:
	angle += delta
	
## Forces state-forceable minions in [member MinionManager._minions] to change state.
## Takes [String] [param state_name] as the name of the new state.
func group_change_state(state_name: String) -> void:
	for minion in _get_forceable_minions():
		minion.minion_state_machine.change_state_safe(state_name)

func _get_transition_state() -> String:
	match state_machine.get_current_state().name:
		"minion_manager_idle_state":
			return "minion_idle_state"
		"minion_manager_follow_state":
			return "minion_follow_state"

	assert(false, "MINION MANAGER: Undefined state transition.")
	return ""

## Should be called when a minion with [int] [param index] is ready to change state and has to wait for other minions to catch up.
## When all forceable minions call [method MinionManager.mark_ready],
## they will be forced to change state based on the [String] [param state_name] parameter.
func mark_ready(index: int) -> void:
	if _ready_minions.has(index): return
	
	var next_state_name: String = _get_transition_state()
	
	_ready_minions.append(index)
	var count_forceable: int = len(_get_forceable_minions())
	if count_forceable == len(_ready_minions):
		_ready_minions.clear()
		group_change_state(next_state_name)

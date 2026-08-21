@icon("res://addons/at-icons/node2d/brain.svg")
class_name MinionManager
extends Node

@export var state_machine: MinionManagerStateMachine

@onready var entity: Entity = get_parent() as Entity

var _minions: Array[Minion] = []
var _minion_count: int = 0
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
	
func minion_offset(index: int) -> float:
	return (TAU / _minion_count) * index
	
## Increases internal [member MinionManager.angle] value used for determining current idle position of each minion.
## Takes [float] [param delta] as increment.
func inc_angle(delta: float) -> void:
	angle += delta
	
## Forces state-forceable minions in [member MinionManager._minions] to change state to idle.
func idle_minions() -> void:
	for minion in _minions:
		minion.minion_state_machine.change_state_group("minion_idle_state")
	
## Forces state-forceable minions in [member MinionManager._minions] to change state to follow.
func follow_minions() -> void:
	for minion in _minions:
		minion.minion_state_machine.change_state_group("minion_follow_state")

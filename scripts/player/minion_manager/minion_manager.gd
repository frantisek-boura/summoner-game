@icon("res://addons/at-icons/node2d/brain.svg")
class_name MinionManager
extends Node2D

const IDLE_RADIUS: float = 300.0
const IDLE_RADIUS_Y_MULTIPLIER: float = 0.5

@export var radial_minion_menu: RadialMinionMenu
@export var minion_path: MinionPath
@export_range(0, 1, 0.001) var idle_rotation_speed: float = 0.5

@onready var entity: Entity = get_parent() as Entity

var selected_minion: Minion = null
var is_idling: bool = false
var angle: float = 0
var _minions: Array[Minion] = []
var _forcible_minions: Array[Minion] = []
var _by_index: Callable = func(m1: Minion, m2: Minion): return m1.index < m2.index

signal forcible_minions_changed(minions: Array[Minion])

func _ready() -> void:
	assert(radial_minion_menu != null, "MINION MANAGER: Radial Minion Menu not set.")
	assert(minion_path != null, "MINION MANAGER: Minion Path not set.")
	assert(entity != null, "MINION MANAGER: Entity not set.")
	
	child_entered_tree.connect(_scan_minions.bind(false))
	child_exiting_tree.connect(_scan_minions.bind(true))
	radial_minion_menu.minion_selected.connect(_on_minion_selected)
	
	_scan_minions(null, false)

func _physics_process(delta: float) -> void:
	_inc_angle(delta)

## Increases internal [member MinionManager.angle] value used for determining current idle position of each minion.
## Takes [float] [param delta] as increment.
func _inc_angle(delta: float) -> void:
	angle -= delta * idle_rotation_speed

func _on_minion_selected(minion: Minion) -> void:
	print("Selected minion: %s" % minion.name)

## Scans child nodes for minions and adds them to [member MinionManager._minions].
## Is invoked on _ready and whenever a node enters/leaves child tree of [MinionManager]
func _scan_minions(node: Node, is_deleting: bool) -> void:
	var new_minions: Array[Minion] = []
	var new_minion_count: int = 0
	var new_forcible_minions: Array[Minion] = []
	
	for minion: Minion in get_children().filter(func(c: Node): return c is Minion):
		if minion == node and is_deleting:
			minion.minion_state_machine.forcible_changed.disconnect(_on_forcible_changed.bind(minion))
			continue
	
		if not minion.minion_state_machine.forcible_changed.is_connected(_on_forcible_changed.bind(minion)):
			minion.minion_state_machine.forcible_changed.connect(_on_forcible_changed.bind(minion))
		
		new_minion_count += 1
		minion.index = new_minion_count
			
		new_minions.append(minion)
		
		if not minion.minion_state_machine.is_forcible(): continue
		new_forcible_minions.append(minion)
	
	new_minions.sort_custom(_by_index)
	new_forcible_minions.sort_custom(_by_index)
	
	_minions = new_minions
	_forcible_minions = new_forcible_minions
	minion_path.init_points(len(_minions))
	radial_minion_menu.set_options(_forcible_minions)
	
## Forces minions that can be forced into the idle state.
func idle_minions() -> void:
	for minion: Minion in _forcible_minions:
		minion.minion_state_machine.change_state_safe("minion_idle_state")
	is_idling = true
	radial_minion_menu.show()
		
## Forces minions that can be forced into the follow state.
func follow_minions() -> void:
	for minion: Minion in _forcible_minions:
		minion.minion_state_machine.change_state_safe("minion_move_to_entity_state")
	is_idling = false
	radial_minion_menu.hide()
	
## Invoked when the state of a minion's [signal MinionStateMachine.forcible_changed] is emitted.
## Handles 
func _on_forcible_changed(is_enabled: bool, minion: Minion) -> void:
	if is_enabled:
		_forcible_minions.append(minion)
		_forcible_minions.sort_custom(_by_index)
		if is_idling:
			minion.minion_state_machine.change_state_safe("minion_idle_state")
		else:
			minion.minion_state_machine.change_state_safe("minion_move_to_entity_state")
	else:
		_forcible_minions.erase(minion)
	forcible_minions_changed.emit(_forcible_minions)
	
## Returns the position of the entity this minion belongs to.
func get_entity_position() -> Vector2:
	return entity.global_position
	
func get_forcible_minion_index(minion_index: int) -> int:
	var forcible_indices: Array = _forcible_minions.map(func(m: Minion): return m.index)
	assert(forcible_indices.has(minion_index), "MINION MANAGER: Index of forcible minion not found.")
	
	return forcible_indices.find(minion_index)
	
func set_minion_independent(minion_index: int, state_name: String) -> void:
	var forcible_indices: Array = _forcible_minions.map(func(m: Minion): return m.index)
	assert(forcible_indices.has(minion_index), "MINION MANAGER: Index of forcible minion not found.")
	
	var minion: Minion = _forcible_minions[minion_index]
	minion.minion_state_machine.set_forcible(false)
	minion.minion_state_machine.change_state(state_name)
	
func set_minion_forcible(minion_index: int) -> void:
	var indices: Array = _minions.map(func(m: Minion): return m.index)
	assert(indices.has(minion_index), "MINION MANAGER: Index of minion not found.")
	
	var minion: Minion = _minions[minion_index]
	minion.minion_state_machine.set_forcible(true)
	
## Returns the radial offset by minion index in rads.
## Expects the result of [method MinionManager.get_forcible_minion_index] as [param forcible_position_index].
func minion_offset(forcible_minion_index: int) -> float:
	return (TAU / len(_forcible_minions)) * forcible_minion_index
	
## Forces state-forcible minions in [member MinionManager._minions] to change state.
## Takes [String] [param state_name] as the name of the new state.
func group_change_state(state_name: String) -> void:
	for minion in _forcible_minions:
		minion.minion_state_machine.change_state_safe(state_name)

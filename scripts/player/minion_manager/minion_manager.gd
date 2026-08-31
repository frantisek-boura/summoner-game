@icon("res://addons/at-icons/node2d/brain.svg")
class_name MinionManager
extends Node2D
## MinionManager controls the entire minion system.
##
## This node utilizes nodes like [RadialMinionMenu], [SelectedMinionIndicator], [MinionHandler] and [MinionPath] to control minions.

const MAX_MINIONS_COUNT: int = 12
const IDLE_RADIUS: float = 300.0
const IDLE_RADIUS_Y_MULTIPLIER: float = 0.5

@export var radial_minion_menu: RadialMinionMenu
@export var selected_minion_indicator: SelectedMinionIndicator
@export var minion_path: MinionPath
@export var minion_handler: MinionHandler
@export var state_machine: MinionManagerStateMachine
@export_range(0, 1, 0.001) var idle_rotation_speed: float = 0.3
@export var minion_types: Array[PackedScene] = []

@onready var entity: Entity = get_parent() as Entity

var selected_minion: Minion = null
var angle: float = 0

func _ready() -> void:
	assert(radial_minion_menu != null, "MINION MANAGER: Radial Minion Menu not set.")
	assert(selected_minion_indicator != null, "MINION MANAGER: Selected Minion Indicator not set.")
	assert(minion_path != null, "MINION MANAGER: Minion Path not set.")
	assert(minion_handler != null, "MINION MANAGER: Minion Handler not set.")
	assert(state_machine != null, "MINION MANAGER: State Machine not set.")
	assert(entity != null, "MINION MANAGER: Entity not set.")
	
	radial_minion_menu.minion_selected.connect(_on_minion_selected)
	minion_handler.minion_tree_changed.connect(_on_minion_tree_changed)
	minion_handler.forcible_minions_changed.connect(_on_forcible_minions_changed)
	minion_path.update_timer.timeout.connect(_on_path_updated)
	
	minion_handler.reorganize_minions()
	minion_path.init_points(entity.global_position)
	radial_minion_menu.set_options(minion_handler.forcible_minions.keys())

## Increases internal [member MinionManager.angle] value used for determining current idle position of each minion.
## Takes [float] [param delta] as increment.
func inc_angle(delta: float) -> void:
	angle -= delta * idle_rotation_speed
	
func add_default_minion() -> void:
	if len(minion_handler.minions) >= MinionManager.MAX_MINIONS_COUNT:
		return
	var minion_position: Vector2 = minion_path.points[len(minion_handler.minions)].global_position
	minion_handler.add_minion(minion_types[0], minion_position)
	
func enable_path_updates() -> void:
	minion_path.start_update_timer()
	
func disable_path_updates() -> void:
	minion_path.stop_update_timer()

func change_to_select_state() -> void:
	state_machine.change_state("minion_manager_select_state")

func change_to_follow_state() -> void:
	state_machine.change_state("minion_manager_follow_state")

func _update_minion_follow_points() -> void:
	for minion: Minion in minion_handler.forcible_minions.keys():
		var path_index: int = minion_handler.forcible_minions[minion]
		var follow_position: Vector2 = minion_path.points[path_index].global_position
		minion.set_follow_path(follow_position)

func _on_minion_selected(minion: Minion) -> void:
	selected_minion = minion
	selected_minion_indicator.enable(minion)

func _on_minion_tree_changed(_new_minion: Minion = null) -> void:
	radial_minion_menu.set_options(minion_handler.forcible_minions.keys())
	_update_minion_follow_points()
	
func _on_forcible_minions_changed() -> void:
	radial_minion_menu.set_options(minion_handler.forcible_minions.keys())
	_update_minion_follow_points()
	
func _on_path_updated() -> void:
	minion_path.update_point(entity.global_position)
	_update_minion_follow_points()

func force_minions_select() -> void:
	for minion: Minion in minion_handler.forcible_minions.keys():
		minion.state_machine.change_state_safe("minion_idle_state")
		
func force_minions_follow() -> void:
	for minion: Minion in minion_handler.forcible_minions.keys():
		minion.state_machine.change_state_safe("minion_follow_state")
		
func open_selection_menu() -> void:
	radial_minion_menu.show()
	
func close_selection_menu(make_selection: bool) -> void:
	radial_minion_menu.hide()
	radial_minion_menu.make_selection()

### Invoked when the state of a minion's [signal MinionStateMachine.forcible_changed] is emitted.
### Handles 
#func _on_forcible_changed(is_enabled: bool, minion: Minion) -> void:
	#if is_enabled:
		#_forcible_minions.append(minion)
		#_forcible_minions.sort_custom(_by_index)
		#if is_idling:
			#minion.minion_state_machine.change_state_safe("minion_idle_state")
		#else:
			#minion.minion_state_machine.change_state_safe("minion_move_to_entity_state")
	#else:
		#_forcible_minions.erase(minion)
	#forcible_minions_changed.emit(_forcible_minions)
	#
### Returns the position of the entity this minion belongs to.
#func get_entity_position() -> Vector2:
	#return entity.global_position
	#
#func get_forcible_minion_index(minion_index: int) -> int:
	#var forcible_indices: Array = _forcible_minions.map(func(m: Minion): return m.index)
	#assert(forcible_indices.has(minion_index), "MINION MANAGER: Index of forcible minion not found.")
	#
	#return forcible_indices.find(minion_index)
	#
#func set_minion_independent(state_name: String) -> void:
	#if selected_minion == null: return
	#
	#var minion: Minion = selected_minion
	#
	#minion.minion_state_machine.set_forcible(false)
	#minion.minion_state_machine.change_state(state_name)
	#
#func set_minion_forcible() -> void:
	#if selected_minion == null: return
	#
	#var minion: Minion = selected_minion
	#minion.minion_state_machine.set_forcible(true)
	#
### Returns the radial offset by minion index in rads.
### Expects the result of [method MinionManager.get_forcible_minion_index] as [param forcible_position_index].
#func minion_offset(forcible_minion_index: int) -> float:
	#return (TAU / len(_forcible_minions)) * forcible_minion_index
	#
### Forces state-forcible minions in [member MinionManager._minions] to change state.
### Takes [String] [param state_name] as the name of the new state.
#func group_change_state(state_name: String) -> void:
	#for minion in _forcible_minions:
		#minion.minion_state_machine.change_state_safe(state_name)

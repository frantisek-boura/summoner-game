@icon("res://addons/at-icons/node2d/brain.svg")
class_name MinionManager
extends Node2D
## MinionManager controls the entire minion system.
##
## This node utilizes nodes like [RadialMinionMenu], [SelectedMinionIndicator], [MinionHandler] and [MinionPath] to control minions.
## Handles minion instantiation/erasure, keeps track of minions, changes minion states, assigns minion tasks, selects/deselects minions.

const MAX_MINIONS_COUNT: int = 8
const IDLE_RADIUS: float = 300.0
const IDLE_RADIUS_Y_MULTIPLIER: float = 0.5

@export_range(0, 1, 0.001) var idle_rotation_speed: float = 0.3
@export var radial_minion_menu: RadialMinionMenu
@export var selected_minion_indicator: SelectedMinionIndicator
@export var minion_path: MinionPath
@export var minion_handler: MinionHandler
@export var state_machine: MinionManagerStateMachine
@export var minion_types: Array[PackedScene] = []

@onready var entity: Entity = get_parent() as Entity

var selected_minion: Minion = null
var angle: float = 0

signal selection_ready

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
	minion_handler.all_minions_ready.connect(_on_all_minions_ready)
	
	minion_handler.reorganize_minions()
	minion_path.init_points(entity.global_position)
	radial_minion_menu.set_options(minion_handler.forcible_minions.keys())
	_hook_minion_signals()

## Increases internal [member MinionManager.angle] value used for determining current idle position of each minion.
## Takes [float] [param delta] as increment.
func inc_angle(delta: float) -> void:
	angle -= delta * idle_rotation_speed
	
func is_selecting() -> bool:
	return state_machine.get_current_state().name == "minion_manager_select_state"
	
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

func force_minions_select() -> void:
	for minion: Minion in minion_handler.forcible_minions.keys():
		minion.state_machine.change_to_select_state()
		
func force_minions_follow() -> void:
	for minion: Minion in minion_handler.forcible_minions.keys():
		minion.state_machine.change_to_follow_state()
		
func open_selection_menu() -> void:
	radial_minion_menu.show()
	
func close_selection_menu(make_selection: bool) -> void:
	radial_minion_menu.hide()
	if make_selection:
		radial_minion_menu.make_selection()
	angle = 0

func update_minion_owner_position(target_minion: Minion = null) -> void:
	if not is_instance_valid(target_minion):
		for minion: Minion in minion_handler.forcible_minions.keys():
			minion.movement.set_owner_position(entity.global_position) 
	else:
		target_minion.movement.set_owner_position(entity.global_position) 

func update_minion_select_positions(target_minion: Minion = null) -> void:
	if not is_instance_valid(target_minion):
		for minion: Minion in minion_handler.forcible_minions.keys():
			var forcible_minions_index: int = minion_handler.forcible_minions[minion]
			minion.movement.set_select_position(angle, entity.global_position, len(minion_handler.forcible_minions), forcible_minions_index)
	else:
		var forcible_minions_index: int = minion_handler.forcible_minions[target_minion]
		target_minion.movement.set_select_position(angle, entity.global_position, len(minion_handler.forcible_minions), forcible_minions_index)

func update_minion_follow_points(target_minion: Minion = null) -> void:
	if not is_instance_valid(target_minion):
		for minion: Minion in minion_handler.forcible_minions.keys():
			var path_index: int = minion_handler.forcible_minions[minion]
			var follow_position: Vector2 = minion_path.points[path_index].global_position
			minion.movement.set_follow_position(follow_position)
	else:
		var path_index: int = minion_handler.forcible_minions[target_minion]
		var follow_position: Vector2 = minion_path.points[path_index].global_position
		target_minion.movement.set_follow_position(follow_position)

func _on_minion_selected(minion: Minion) -> void:
	selected_minion = minion
	selected_minion_indicator.enable(minion)

func _on_all_minions_ready(new_state: State) -> void:
	for minion: Minion in minion_handler.forcible_minions.keys():
		minion.state_machine.change_state_safe(new_state.name)

func _change_new_minion_state(new_minion: Minion) -> void:
	var current_state: String = state_machine.get_current_state().name
	if current_state == "minion_manager_follow_state":
		new_minion.state_machine.change_state_safe("minion_follow_state_2")
		update_minion_follow_points()
	elif current_state == "minion_manager_select_state":
		new_minion.state_machine.change_state_safe("minion_select_state_3")
		update_minion_select_positions()

func _hook_minion_signals() -> void:
	for minion: Minion in minion_handler.minions.keys():
		if minion.state_machine.ready_up.is_connected(minion_handler.ready_up.bind(minion)):
			minion.state_machine.ready_up.disconnect(minion_handler.ready_up.bind(minion))
		
		if minion.movement.request_follow_position.is_connected(_on_follow_position_requested):
			minion.movement.request_follow_position.disconnect(_on_follow_position_requested)
			
		if minion.movement.request_select_position.is_connected(_on_select_position_requested):
			minion.movement.request_select_position.disconnect(_on_select_position_requested)
			
		if minion.movement.request_owner_position.is_connected(_on_owner_position_requested):
			minion.movement.request_owner_position.disconnect(_on_owner_position_requested)
			
		if minion.movement.in_select_position.is_connected(_on_in_select_position):
			minion.movement.in_select_position.disconnect(_on_in_select_position)
			
		if minion.movement.in_owner_position.is_connected(_on_in_owner_position):
			minion.movement.in_owner_position.disconnect(_on_in_owner_position)
		
		if minion_handler.forcible_minions.keys().has(minion):
			minion.state_machine.ready_up.connect(minion_handler.ready_up.bind(minion))
			minion.movement.request_follow_position.connect(_on_follow_position_requested)
			minion.movement.request_select_position.connect(_on_select_position_requested)
			minion.movement.request_owner_position.connect(_on_owner_position_requested)
			minion.movement.in_select_position.connect(_on_in_select_position)
			minion.movement.in_owner_position.connect(_on_in_owner_position)

func _on_follow_position_requested(minion: Minion) -> void:
	var path_index: int = minion_handler.forcible_minions[minion]
	var follow_position: Vector2 = minion_path.points[path_index].global_position
	minion.movement.set_follow_position(follow_position)

func _on_select_position_requested(minion: Minion) -> void:
	var forcible_minions_index: int = minion_handler.forcible_minions[minion]
	minion.movement.set_select_position(angle, entity.global_position, len(minion_handler.forcible_minions), forcible_minions_index)

func _on_owner_position_requested(minion: Minion) -> void:
	minion.movement.set_owner_position(entity.global_position)
	
func _on_in_select_position() -> void:
	selection_ready.emit()
	
func _on_in_owner_position() -> void:
	open_selection_menu()

func _on_minion_tree_changed(minion: Minion = null) -> void:
	if not is_instance_valid(minion):
		_minions_changed(false, null)
	else:
		minion.global_position = entity.global_position
		_minions_changed(minion.state_machine.is_forcible, minion)
	
func _on_forcible_minions_changed(is_enabled: bool, minion: Minion) -> void:
	_minions_changed(is_enabled, minion)
	
func _on_path_updated() -> void:
	minion_path.update_point(entity.global_position)
	
func _minions_changed(is_forcible: bool, minion: Minion = null) -> void:
	radial_minion_menu.set_options(minion_handler.forcible_minions.keys())
	if is_instance_valid(minion) and minion.state_machine.is_forcible:
		call_deferred("_change_new_minion_state", minion)
		call_deferred("_hook_minion_signals")

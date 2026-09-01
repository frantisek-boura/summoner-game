@icon("res://addons/at-icons/node2d/list_checkboxes.svg")
extends Node2D
class_name MinionHandler
## MinionHandler is used for handling minion instances.
##
## Its responsibilities include keeping track of which minions can have its state forced by [MinionManager],
## limiting minion instances within its child tree, creating and removing new minion instances, reacting to
## changes in child tree and changes in regards to each minion's [member MinionStateMachine.is_forcible] value.
## [br]
## This node is directly controlled by [MinionManager].

## Collection of all minions instances that can be interacted with.
var minions: Dictionary[Minion, int] = {}
## Collection of minions that can be forced to change state.
var forcible_minions: Dictionary[Minion, int] = {}

## Emitted when [MinionHandler]'s tree of child nodes changes.
signal minion_tree_changed(new_minion: Minion)
## Emitted when a minion changes their [member MinionStateMachine.is_forcible] value.
signal forcible_minions_changed(is_enabled: bool, new_minion: Minion)

func _ready() -> void:
	child_entered_tree.connect(_on_minion_tree_changed.bind(false))
	child_exiting_tree.connect(_on_minion_tree_changed.bind(true))

## Instantiates a new minion scene based on the [param minion_scene] provided at [param new_position] position.
## Does nothing if [member MinionHandler.minions] contains [const MinionManager.MAX_MINIONS_COUNT] or more instances.
func add_minion(minion_scene: PackedScene, new_position: Vector2) -> void:
	if len(minions) >= MinionManager.MAX_MINIONS_COUNT:
		return
	var minion: Minion = minion_scene.instantiate()
	minion.global_position = new_position
	add_child(minion)

## Removes the provided [param minion] instance.
## Does nothing if [member MinionHandler.minions] has 0 instances.
func remove_minion(minion: Minion) -> void:
	if len(minions) == 0 or not is_instance_valid(minion):
		return
	minion.queue_free()

## Serves as a handler to call [method _reorganize_minions] from the outside for initialization purposes.
## Used by [MinionManager] at the end of its own initialization.
func reorganize_minions() -> void:
	_reorganize_minions(null, false)

## Sorts child nodes of type [Minion] into [member minions] and [member forcible_minions].
## Is called when the tree of child nodes detects a change or when a minion's [member MinionStateMachine.is_forcible] value is changed. 
## Parameter [param target_node] is a reference to the node being added/deleted, [param is_deleting] is a flag that decides
## whether [param target_node] is being added or deleted.
func _reorganize_minions(target_node: Node = null, is_deleting: bool = false) -> void:
	var new_minions: Dictionary[Minion, int] = {}
	var new_forcible_minions: Dictionary[Minion, int] = {}
	
	var new_minion_count: int = 0
	var new_forcible_minion_count: int = 0
	for minion: Minion in get_children():
		if minion == target_node and is_deleting:
			if minion.state_machine.forcible_changed.is_connected(_on_forcible_changed.bind(minion)):
				minion.state_machine.forcible_changed.disconnect(_on_forcible_changed.bind(minion))
			continue
	
		if not minion.state_machine.forcible_changed.is_connected(_on_forcible_changed.bind(minion)):
			minion.state_machine.forcible_changed.connect(_on_forcible_changed.bind(minion))
		
		new_minions.set(minion, new_minion_count)
		new_minion_count += 1
		
		if minion.state_machine.is_forcible:
			new_forcible_minions.set(minion, new_forcible_minion_count)
			new_forcible_minion_count += 1
			
	minions = new_minions
	forcible_minions = new_forcible_minions

## Reacts to changes in tree of child nodes. 
## Checks for count of minions in child tree and removes extra minions, reorganizes minions,
## and emits [signal MinionHandler.minion_tree_changed] to signal that minions have been reorganized.
func _on_minion_tree_changed(target_node: Node = null, is_deleting: bool = false) -> void:
	if len(get_children()) > MinionManager.MAX_MINIONS_COUNT and not is_deleting:
		target_node.queue_free()
		return
	
	_reorganize_minions(target_node, is_deleting)
	minion_tree_changed.emit(target_node as Minion if not is_deleting else null)

## Reacts to changes in [Minion] child nodes' [member MinionStateMachine.is_forcible] values.
## Reorganizes minions and emits [signal MinionHandler.forcible_minions_changed] to signal that minions have changed their forcible states.
func _on_forcible_changed(is_enabled: bool, minion: Minion) -> void:
	_reorganize_minions()
	forcible_minions_changed.emit(is_enabled, minion)

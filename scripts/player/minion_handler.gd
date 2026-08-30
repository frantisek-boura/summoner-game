@icon("res://addons/at-icons/node2d/list_checkboxes.svg")
extends Node2D
class_name MinionHandler

## Collection of all minions.
var minions: Dictionary[Minion, int] = {}
## Collection of minions that can be forced to change state by [MinionManager]
var forcible_minions: Dictionary[Minion, int] = {}

## Emitted when [MinionHandler]'s tree of child nodes changes.
signal minion_tree_changed(new_minion: Minion)
## Emitted when a minion changes their forcible status.
signal forcible_minions_changed(is_enabled: bool, new_minion: Minion)

func _ready() -> void:
	child_entered_tree.connect(_on_minion_tree_changed.bind(false))
	child_exiting_tree.connect(_on_minion_tree_changed.bind(true))

# TODO: Minion Add/Remove methods. Has to check maximum mininos when adding.

func reorganize_minions() -> void:
	_reorganize_minions(null, false)

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
		
		if minion.state_machine.is_forcible():
			new_forcible_minions.set(minion, new_forcible_minion_count)
			new_forcible_minion_count += 1
			
	minions = new_minions
	forcible_minions = new_forcible_minions

func _on_minion_tree_changed(target_node: Node = null, is_deleting: bool = false) -> void:
	if len(get_children()) > MinionManager.MAX_MINIONS_COUNT and not is_deleting:
		target_node.queue_free()
		return
	
	_reorganize_minions(target_node, is_deleting)
	minion_tree_changed.emit(target_node as Minion if not is_deleting else null)

func _on_forcible_changed(is_enabled: bool, minion: Minion) -> void:
	_reorganize_minions()
	forcible_minions_changed.emit(is_enabled, minion)

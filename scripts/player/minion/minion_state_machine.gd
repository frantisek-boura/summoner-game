class_name MinionStateMachine
extends StateMachine

@export var _is_forcible: bool = true

signal forcible_changed(is_enabled: bool)

## Decides whether this stateful node can be forced to change state.
## Emits [signal MinionStateMachine.forcible_changed] when the state of internal member [member MinionStateMachine._is_forcible] is changed.
## Takes [bool] [param is_enabled] to decide.
func set_forcible(is_enabled: bool) -> void:
	var old_value: bool = _is_forcible
	_is_forcible = is_enabled
	
	if old_value != _is_forcible:
		forcible_changed.emit(_is_forcible)
	
## Returns whether the minion's state can be forced or not.
func is_forcible() -> bool:
	return _is_forcible

## This method is an extension of [method StateMachine.change_state] that takes into account [member MinionStateMachine._is_forcible] value.
## This method is meant to be used on multiple stateful objects at once to filter out those that aren't supposed to change state. [br][br]
## Takes [String] [param state_name] for the name of the new state's node.
func change_state_safe(state_name: String) -> void:
	if not _is_forcible or _changing_state: return
	
	_change_state(state_name)

class_name MinionStateMachine
extends StateMachine

## Decides whether this stateful node can be forced to change state.
## Emits [signal MinionStateMachine.forcible_changed] when the state of internal member [member MinionStateMachine._is_forcible] is changed.
var is_forcible: bool = true:
	set(value):
		var old_value: bool = is_forcible
		is_forcible = value
		
		if old_value != value:
			forcible_changed.emit(is_forcible)
	get:
		return is_forcible

signal forcible_changed(is_enabled: bool)

## Changes the player's state to idle.
func change_to_follow_state() -> void:
	_change_state_safe("minion_follow_state")
	
## Changes the player's state to idle.
func change_to_select_state() -> void:
	_change_state_safe("minion_select_state")

## This method is an extension of [method StateMachine.change_state] that takes into account [member MinionStateMachine._is_forcible] value.
## This method is meant to be used on multiple stateful objects at once to filter out those that aren't supposed to change state. [br][br]
## Takes [String] [param state_name] for the name of the new state's node.
func _change_state_safe(state_name: String) -> void:
	if not is_forcible or _changing_state: return
	
	_change_state(state_name)

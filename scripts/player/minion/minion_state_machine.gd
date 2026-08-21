class_name MinionStateMachine
extends StateMachine

@export var _can_be_forced: bool = true

## Decides whether this stateful node can be forced to change state
## Takes [bool] [param is_enabled] to decide.
func enable_can_be_forced(is_enabled: bool) -> void:
	_can_be_forced = is_enabled

## This method is an extension of [method StateMachine.change_state] that takes into account [member MinionStateMachine._can_be_forced] value.
## This method is meant to be used on multiple stateful objects at once to filter out those that aren't supposed to change state. [br][br]
## Takes [String] [param state_name] for the name of the new state's node.
func change_state_group(state_name: String) -> void:
	if not _can_be_forced or _changing_state: return
	
	_change_state(state_name)

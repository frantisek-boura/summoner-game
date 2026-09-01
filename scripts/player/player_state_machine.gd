class_name PlayerStateMachine
extends StateMachine

## Changes the player's state to move.
func change_to_move_state() -> void:
	change_state("player_move_state")

## Changes the player's state to idle.
func change_to_idle_state() -> void:
	change_state("player_idle_state")

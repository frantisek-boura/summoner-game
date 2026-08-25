@icon("res://addons/at-icons/node/arrow_right_to_line.svg")
@abstract class_name State 
extends Node

@export var timer: Timer = null

@onready var state_machine: StateMachine = get_parent() as StateMachine

## Called on the new state when [StateMachine] changes states.
@abstract func enter() -> void
## Called on the old state when [StateMachine] changes states.
@abstract func exit() -> void
## Called every frame when this state is active with the purpose of rendering visuals.
@abstract func frames(delta: float) -> void
## Called every physics frame when this state is active with the purpose of updating physics.
@abstract func physics(delta: float) -> void
## Called every frame when this state is active with the purpose of catching continuous player input.
@abstract func input_process(delta: float) -> void
## Called on player input event when this state is active.
@abstract func input_event(event: InputEvent) -> void

class_name MinionIdleState
extends State

@export var minion: Minion

func _ready() -> void:
	assert(minion != null, "MINION IDLE STATE: Stateful node not set")

func enter() -> void:
	minion.movement.reset_velocity()

func exit() -> void:
	pass

func frames(_delta: float) -> void:
	pass

func physics(delta: float) -> void:
	minion.movement.move_select(delta)

func input_process(_delta: float) -> void:
	pass

func input_event(_event: InputEvent) -> void:
	pass

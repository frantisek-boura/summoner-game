class_name MinionIdleState
extends State

@export var minion: Minion

func _ready() -> void:
	assert(minion != null, "MINION IDLE STATE: Stateful node not set")

func enter() -> void:
	pass

func exit() -> void:
	pass

func frames(_delta: float) -> void:
	pass

func physics(delta: float) -> void:
	var idle_position: Vector2 = minion.minion_movement.get_idle_position()
	minion.minion_movement.lock_in_position(delta, idle_position)

func input_process(_delta: float) -> void:
	pass

func input_event(_event: InputEvent) -> void:
	pass

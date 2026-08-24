class_name MinionFollowState
extends State

@export var minion: Minion

func _ready() -> void:
	assert(minion != null, "MINION FOLLOW STATE: Stateful node not set")

func enter() -> void:
	pass

func exit() -> void:
	minion.minion_movement.reset_velocity()

func frames(_delta: float) -> void:
	pass

func physics(delta: float) -> void:
	minion.minion_movement.follow_entity(delta)

func input_process(_delta: float) -> void:
	pass

func input_event(_event: InputEvent) -> void:
	pass

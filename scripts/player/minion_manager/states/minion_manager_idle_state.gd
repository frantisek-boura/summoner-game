class_name MinionManagerIdleState
extends State

@export var minion_manager: MinionManager

func _ready() -> void:
	assert(minion_manager != null, "MINION MANAGER IDLE STATE: Stateful node not set")

func enter() -> void:
	minion_manager.idle_minions()

func exit() -> void:
	pass

func frames(_delta: float) -> void:
	pass

func physics(delta: float) -> void:
	minion_manager.inc_angle(delta)

func input_process(_delta: float) -> void:
	pass

func input_event(_event: InputEvent) -> void:
	pass

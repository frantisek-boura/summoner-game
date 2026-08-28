class_name MinionManagerFollowState
extends State

@export var minion_manager: MinionManager

func _ready() -> void:
	assert(minion_manager != null, "MINION MANAGER FOLLOW STATE: Stateful node not set")

func enter() -> void:
	pass

func exit() -> void:
	pass

func frames(_delta: float) -> void:
	pass

func physics(_delta: float) -> void:
	pass

func input_process(_delta: float) -> void:
	pass

func input_event(_event: InputEvent) -> void:
	pass

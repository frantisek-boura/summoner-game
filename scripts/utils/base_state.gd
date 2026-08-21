class_name BaseState
extends State

@export var entity: Entity

func _ready() -> void:
	assert(entity != null, "BASE STATE: Stateful node not set")

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

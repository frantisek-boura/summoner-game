class_name MinionMoveToEntityState
extends State

@export var minion: Minion

func _ready() -> void:
	assert(minion != null, "MINION MOVE TO ENTITY STATE: Stateful node not set")
	
	if timer != null:
		timer.timeout.connect(_on_timeout)

func enter() -> void:
	timer.start()

func exit() -> void:
	timer.stop()

func frames(_delta: float) -> State:
	return null

func physics(_delta: float) -> State:
	return null

func input_process(_delta: float) -> State:
	return null

func input_event(_event: InputEvent) -> State:
	return null
	
func _on_timeout() -> void:
	timer.stop()

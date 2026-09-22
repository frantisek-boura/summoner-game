class_name MinionFollowState2
extends State

@export var minion: Minion

var _marked_ready: bool = false

func _ready() -> void:
	assert(minion != null, "MINION FOLLOW STATE: Stateful node not set")

func enter() -> void:
	_marked_ready = false
	minion.movement.reset_velocity()
	
	minion.movement.request_follow_position.emit(minion)
	await minion.movement.target_position_received
	
func exit() -> void:
	pass

func frames(_delta: float) -> State:
	return null

func physics(_delta: float) -> State:
	if not minion.movement.has_arrived():
		minion.movement.lerp_follow()
	minion.movement.request_follow_position.emit(minion)
	await minion.movement.target_position_received
		
	return null

func input_process(_delta: float) -> State:
	return null

func input_event(_event: InputEvent) -> State:
	return null

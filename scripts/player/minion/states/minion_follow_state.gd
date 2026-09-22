class_name MinionFollowState
extends State

@export var minion_follow_state_2: State
@export var minion: Minion

var _marked_ready: bool = false

func _ready() -> void:
	assert(minion != null, "MINION FOLLOW STATE: Stateful node not set")
	assert(minion_follow_state_2 != null, "MINION FOLLOW STATE: Follow State 2 node not set")

func enter() -> void:
	_marked_ready = false
	minion.movement.reset_velocity()
	
	minion.movement.request_owner_position.emit(minion)
	await minion.movement.target_position_received

func exit() -> void:
	pass

func frames(_delta: float) -> State:
	return null

func physics(_delta: float) -> State:
	minion.movement.lerp_owner()
	if minion.movement.has_arrived() and not _marked_ready:
		minion.state_machine.ready_up.emit(minion_follow_state_2)
		_marked_ready = true
		
	return null

func input_process(_delta: float) -> State:
	return null

func input_event(_event: InputEvent) -> State:
	return null

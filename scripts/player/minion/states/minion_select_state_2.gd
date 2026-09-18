class_name MinionSelectState2
extends State

@export var minion_select_state_3: State
@export var minion: Minion

var _marked_ready: bool = false

func _ready() -> void:
	assert(minion != null, "MINION SELECT STATE 2: Stateful node not set")
	assert(minion_select_state_3 != null, "MINION SELECT STATE 2: Select State 3 node not set")

func enter() -> void:
	_marked_ready = false
	minion.movement.reset_velocity()
	
	minion.movement.request_select_position.emit(minion)
	await minion.movement.target_position_received

func exit() -> void:
	pass

func frames(_delta: float) -> State:
	return null

func physics(_delta: float) -> State:
	minion.movement.lerp_select()
	if minion.movement.has_arrived() and not _marked_ready:
		minion.state_machine.ready_up.emit(minion_select_state_3)
		_marked_ready = true
		
	return null

func input_process(_delta: float) -> State:
	return null

func input_event(_event: InputEvent) -> State:
	return null

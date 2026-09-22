class_name MinionSelectState
extends State

@export var minion_select_state_2: State
@export var minion: Minion

func _ready() -> void:
	assert(minion != null, "MINION SELECT STATE: Stateful node not set")
	assert(minion_select_state_2 != null, "MINION SELECT STATE: Select State 2 node not set")

func enter() -> void:
	minion.movement.reset_velocity()
	
	minion.movement.request_owner_position.emit(minion)
	await minion.movement.target_position_received

func exit() -> void:
	minion.movement.in_owner_position.emit()

func frames(_delta: float) -> State:
	return null

func physics(_delta: float) -> State:
	minion.movement.lerp_owner()
	if minion.movement.has_arrived():
		minion.state_machine.ready_up.emit(minion_select_state_2)
		
	return null

func input_process(_delta: float) -> State:
	return null

func input_event(_event: InputEvent) -> State:
	return null

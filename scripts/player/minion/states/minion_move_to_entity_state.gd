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

func frames(_delta: float) -> void:
	pass

func physics(delta: float) -> void:
	var entity_position: Vector2 = minion.minion_manager.get_entity_position()
	minion.minion_movement.lock_in_position(delta, entity_position)

func input_process(_delta: float) -> void:
	pass

func input_event(_event: InputEvent) -> void:
	pass
	
func _on_timeout() -> void:
	minion.minion_state_machine.change_state_safe("minion_follow_state")
	timer.stop()

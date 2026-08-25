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
	
	if minion.minion_movement.has_arrived(entity_position):
		minion.minion_manager.mark_ready(minion.index)

func input_process(_delta: float) -> void:
	pass

func input_event(_event: InputEvent) -> void:
	pass
	
func _on_timeout() -> void:
	minion.minion_manager.mark_ready(minion.index)
	timer.stop()

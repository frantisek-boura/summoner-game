class_name MinionFollowState
extends State

@export var minion: Minion

func _ready() -> void:
	assert(minion != null, "MINION FOLLOW STATE: Stateful node not set")

func enter() -> void:
	pass

func exit() -> void:
	minion.minion_movement.reset_direction()

func frames(_delta: float) -> void:
	pass

func physics(_delta: float) -> void:
	var entity_position: Vector2 = minion.minion_movement.get_entity_position()
	minion.minion_movement.change_direction(minion.global_position.direction_to(entity_position))
	if minion.minion_movement.has_arrived(entity_position):
		minion.minion_movement.stop()
	else:
		minion.minion_movement.move_to_entity()

func input_process(_delta: float) -> void:
	pass

func input_event(_event: InputEvent) -> void:
	pass

class_name MinionFollowState
extends State

@export var minion: Minion

func _ready() -> void:
	assert(minion != null, "MINION FOLLOW STATE: Stateful node not set")

func enter() -> void:
	pass

func exit() -> void:
	pass

func frames(_delta: float) -> void:
	pass

func physics(_delta: float) -> void:
	var path_point: Vector2 = minion.minion_manager.minion_path.get_follow_position(minion.index)
	if not minion.minion_movement.has_arrived(path_point):
		minion.minion_movement.follow_path()
	else:
		minion.minion_movement.stop()

func input_process(_delta: float) -> void:
	pass

func input_event(_event: InputEvent) -> void:
	pass

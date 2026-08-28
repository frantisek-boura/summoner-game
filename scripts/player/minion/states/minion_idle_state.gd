class_name MinionIdleState
extends State

@export var minion: Minion

func _ready() -> void:
	assert(minion != null, "MINION IDLE STATE: Stateful node not set")

func enter() -> void:
	minion.minion_movement.reset_velocity()

func exit() -> void:
	pass

func frames(_delta: float) -> void:
	pass

func physics(delta: float) -> void:
	#var idle_position: Vector2 = minion.minion_movement.get_idle_position()
	#if not minion.minion_movement.has_arrived(idle_position):
		#minion.minion_movement.idle_around(delta, idle_position)
	#else:
		#minion.minion_movement.lock_in_position(delta, idle_position)
	pass

func input_process(_delta: float) -> void:
	pass

func input_event(_event: InputEvent) -> void:
	pass

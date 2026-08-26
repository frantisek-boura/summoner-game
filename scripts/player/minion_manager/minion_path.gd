@icon("res://addons/at-icons/node2d/itinerary.svg")
class_name MinionPath
extends Node2D

@export var _timer: Timer
@export var _entity: Entity

var _points: Array[Node2D] = []

func _ready() -> void:
	assert(_timer != null, "MINION PATH: Timer not set.")
	
	_timer.timeout.connect(_update_point)
	
func disable_updates() -> void:
	_timer.stop()
	
func enable_updates() -> void:
	_timer.start()
	
func init_points(minion_count: int) -> void:
	_points.clear()
	for child: Node in get_children():
		if child is Timer: continue
		child.queue_free()

	for i: int in minion_count:
		var point: Node2D = Node2D.new()
		point.global_position = _entity.global_position
		_points.append(point)
		add_child(point)

func _update_point() -> void:
	var old_point: Node2D = _points.pop_back() as Node2D
	old_point.global_position = _entity.global_position
	_points.push_front(old_point)
	
func get_follow_position(minion_index: int) -> Vector2:
	return _points.get(minion_index - 1).global_position

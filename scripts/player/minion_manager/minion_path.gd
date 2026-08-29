@icon("res://addons/at-icons/node2d/itinerary.svg")
class_name MinionPath
extends Node2D

@export var update_timer: Timer

var points: Array[Node2D] = []

func _ready() -> void:
	assert(update_timer != null, "MINION PATH: Update timer not set.")

## Stops [member update_timer].
func stop_update_timer() -> void:
	update_timer.stop()
	
## Starts [member update_timer].
func start_update_timer() -> void:
	update_timer.start()

## Handler function for [signal update_timer.timeout].
func update_point(new_position: Vector2) -> void:
	var back: Node2D = points.pop_back()
	back.global_position = new_position
	points.push_front(back)
	
## Used to double the amount of points.
func extend_points(new_position: Vector2) -> void:
	for _i in len(points):
		var point: Node2D = Node2D.new()
		point.global_position = new_position
		points.append(point)
		add_child(point)

## Initializes [param count] amount of points at [param origin_position] position.
func init_points(origin_position: Vector2, count: int) -> void:
	_clear_points()
	
	for _i in count * 2:
		var point: Node2D = Node2D.new()
		point.global_position = origin_position
		points.append(point)
		add_child(point)

## Clears the child tree of all Node2D point nodes.
func _clear_points() -> void:
	for point: Node2D in points:
		point.queue_free()
	points.clear()

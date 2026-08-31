@icon("res://addons/at-icons/node2d/itinerary.svg")
class_name MinionPath
extends Node2D
## MinionPath is used to keep track of the path its owner entity is travelling.
##
## Uses [member MinionPath.update_timer] and [method MinionPath.update_point] to periodically update [member MinionPath.points]. Provides functions
## to enable/disable [member MinionPath.update_timer]. 
## [br]
## This node is directly controlled by [MinionManager].

## The timer node that controls how often [member MinionPath.points] is updated.
@export var update_timer: Timer

## Collection of [Node2D] instances that represent snapshots of owner entity's previous positions.
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
## Signal [signal update_timer.timeout] should be handled inside [MinionManager]
func update_point(new_position: Vector2) -> void:
	var back: Node2D = points.pop_back()
	back.global_position = new_position
	points.push_front(back)

## Initializes [const MinionManager.MAX_MINIONS_COUNT] amount of points at [param origin_position] position.
func init_points(origin_position: Vector2) -> void:
	for point: Node2D in points:
		point.queue_free()
	points.clear()
	
	for _i in MinionManager.MAX_MINIONS_COUNT:
		var point: Node2D = Node2D.new()
		point.global_position = origin_position
		points.append(point)
		add_child(point)

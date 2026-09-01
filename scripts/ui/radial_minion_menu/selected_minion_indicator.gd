@icon("res://addons/at-icons/node2d/selection_circle.svg")
class_name SelectedMinionIndicator
extends Node2D
## SelectedMinionIndicator is used to visually represent the currenlty selected minion, which can be
## selected using [RadialMinionMenu].
## 
## Provides function to enable and disable the highlight.
## [br]
## This node is directly controlled by [MinionManager]

## The minimum radius of the highlight visual.
@export_range(1.00, 100.00, 0.01) var min_radius: float = 50.0
## The maximum radius of the highlight visual.
@export_range(1.00, 100.00, 0.01) var max_radius: float = 100.0
## The animation speed at which the highlight visual expands/contracts.
@export_range(1.00, 100.00, 0.01) var animation_speed: float = 8.0
## The movement speed at which the highlight visual follows its target.
@export_range(1.00, 100.00, 0.01) var follow_speed: float = 64.0
## The color of the highlight visual.
@export var color: Color = Color.YELLOW

## The current radius of the highlight visual.
var _radius: float = 0.0
## Flag that keeps track of whether the highlight visual is expanding or not.
var _is_expanding: bool = false
## The current target of the highlight visual.
var _selected_minion: Minion = null
## The current position of the highlight visual. Used to lerp between this variable's value and [member SelectedMinionIndicator._selected_minion]'s global position.
var _current_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	hide()
	_radius = min_radius

func _draw() -> void:
	if _selected_minion == null:
		return
	
	draw_ellipse(_current_position, _radius, _radius * MinionManager.IDLE_RADIUS_Y_MULTIPLIER, color, false, 5, true)

func _process(_delta: float) -> void:
	if not is_visible_in_tree():
		return
	
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not is_visible_in_tree():
		return
		
	_radius = lerpf(_radius, max_radius if _is_expanding else min_radius, delta * animation_speed)
	if abs(_radius - min_radius) < 0.1:
		_is_expanding = true
	if abs(_radius - max_radius) < 0.1:
		_is_expanding = false
	
	if _selected_minion != null:
		_current_position = lerp(_current_position, _selected_minion.global_position, delta * follow_speed)
	
## Used to set target and render the highlight visual.
func enable(minion: Minion) -> void:
	_selected_minion = minion
	_current_position = lerp(_current_position, _selected_minion.global_position, get_physics_process_delta_time() / follow_speed)
	_radius = min_radius
	show()
	
## Used to hide the highlight visual.
func disable() -> void:
	hide()
	_selected_minion = null
	_current_position = Vector2.ZERO

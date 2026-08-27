@icon("res://addons/at-icons/node2d/selection_circle.svg")
class_name SelectedMinionIndicator
extends Node2D

@export_range(1.00, 100.00, 0.01) var min_radius: float = 50.0
@export_range(1.00, 100.00, 0.01) var max_radius: float = 100.0
@export_range(1.00, 100.00, 0.01) var animation_speed: float = 8.0
@export_range(1.00, 100.00, 0.01) var follow_speed: float = 64.0
@export var color: Color = Color.YELLOW

var _radius: float = 0.0
var _is_rising: bool = false
var _selected_minion: Minion = null
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
		
	_radius = lerpf(_radius, max_radius if _is_rising else min_radius, delta * animation_speed)
	if abs(_radius - min_radius) < 0.1:
		_is_rising = true
	if abs(_radius - max_radius) < 0.1:
		_is_rising = false
	
	if _selected_minion != null:
		_current_position = lerp(_current_position, _selected_minion.global_position, delta * follow_speed)
	
func enable(minion: Minion) -> void:
	disable()
	_selected_minion = minion
	_current_position = _selected_minion.global_position
	_radius = min_radius
	show()
	
func disable() -> void:
	hide()
	_selected_minion = null
	_current_position = Vector2.ZERO

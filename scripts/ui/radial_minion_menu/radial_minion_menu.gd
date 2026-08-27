@icon("res://addons/at-icons/node2d/pie_chart.svg")
class_name RadialMinionMenu
extends Node2D

@export_range(0, 100, 0.01) var expand_speed: float = 10.0
@export var bkg_color: Color = Color.DIM_GRAY
@export var line_color: Color = Color.LIGHT_GRAY
@export var selected_color: Color = Color.SLATE_GRAY
@export var line_width: int = 1

var _selection: int = 0
var _options: Array[Minion] = []
var _radius: float = 0

signal minion_selected(minion: Minion)
signal minion_hovered

func _ready() -> void:
	hide()
	
	visibility_changed.connect(_on_visibility_changed)
	
func make_selection() -> void:
	if len(_options) != 0:
		minion_selected.emit(_options[_selection])
	
func set_options(minions: Array[Minion]) -> void:
	_options = minions
	
func _on_visibility_changed() -> void:
	if not is_visible_in_tree():
		_radius = 0
	
func _get_base_alignment_angle() -> float:
	if _options.is_empty() or not is_instance_valid(_options[0]):
		return 0
		
	var y_mult = MinionManager.IDLE_RADIUS_Y_MULTIPLIER
	var world_dir = _options[0].global_position - global_position
	var circle_dir = Vector2(world_dir.x, world_dir.y / y_mult)
	var slice_size = TAU / _options.size()
	var desired_slice_midpoint = slice_size / 2
	
	return circle_dir.angle() - desired_slice_midpoint

func _draw() -> void:
	var y_mult = MinionManager.IDLE_RADIUS_Y_MULTIPLIER
	var a = _radius
	var b = _radius * y_mult
	
	draw_ellipse(Vector2.ZERO, a, b, bkg_color, true, -1.0, true)
	
	if len(_options) > 0:
		var slice_size = TAU / len(_options)
		var total_offset = _get_base_alignment_angle()
		var visual_index = (len(_options) - _selection) % len(_options)
		var phi1 = total_offset + (slice_size * visual_index)
		var phi2 = total_offset + (slice_size * (visual_index + 1))
		
		var slice_points: PackedVector2Array = [Vector2.ZERO]
		var arc_segments = 32
		
		for s in range(arc_segments + 1):
			var t = lerp(phi1, phi2, float(s) / arc_segments)
			slice_points.append(Vector2(cos(t) * a, sin(t) * b))
		draw_polygon(slice_points, [selected_color])
		
		if len(_options) > 1:
			for i in len(_options):
				var phi = total_offset + (slice_size * i)
				var line_endpoint = Vector2(cos(phi) * a, sin(phi) * b)
				draw_line(Vector2.ZERO, line_endpoint, line_color, line_width, true)
				
	draw_ellipse_arc(Vector2.ZERO, a, b, 0, TAU, 128, line_color, line_width, true)

func _physics_process(delta: float) -> void:
	if not is_visible_in_tree():
		return
	
	if len(_options) <= 0:
		return

	if _radius != MinionManager.IDLE_RADIUS:
		_radius = lerpf(_radius, MinionManager.IDLE_RADIUS + 80, delta * expand_speed)

	var y_mult = MinionManager.IDLE_RADIUS_Y_MULTIPLIER
	var mouse_position = get_local_mouse_position()
	var circle_mouse_pos = Vector2(mouse_position.x, mouse_position.y / y_mult)
	var total_offset = _get_base_alignment_angle()
	var mouse_rads = fposmod(circle_mouse_pos.angle() - total_offset, TAU) 
	var slice_size = TAU / len(_options)
	var raw_slot: int = int(floor(mouse_rads / slice_size))
	
	var _new_selection: int = (len(_options) - raw_slot) % len(_options)
	if _new_selection != _selection:
		minion_hovered.emit()
	
	_selection = _new_selection

func _process(_delta: float) -> void:
	if not is_visible_in_tree():
		return
	
	if len(_options) <= 0:
		return
	
	queue_redraw()

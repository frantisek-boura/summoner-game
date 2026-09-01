class_name PlayerCamera
extends Camera2D

const SELECT_ZOOM: Vector2 = Vector2(1.05, 1.05)
const DEFAULT_ZOOM: Vector2 = Vector2(0.3, 0.3)

@export_range(0.0, 100.0, 0.01) var zoom_speed: float = 0.5
@export_range(0.0, 1.0, 0.01) var zoom_time: float = 0.35

var _current_zoom_target: Vector2 = DEFAULT_ZOOM
var _is_selecting: bool = false
var _time: float = 0

func _physics_process(delta: float) -> void:
	if (get_zoom() / _current_zoom_target) == _current_zoom_target / (SELECT_ZOOM if _is_selecting else DEFAULT_ZOOM):
		return
		
	if _time >= zoom_time: return
	_time += delta
	
	set_zoom(clamp(zoom.lerp(get_zoom() * _current_zoom_target, zoom_speed * delta), DEFAULT_ZOOM, SELECT_ZOOM))

func zoom_to_select() -> void:
	_time = 0
	_is_selecting = false
	_current_zoom_target = SELECT_ZOOM
	
func zoom_to_default() -> void:
	_time = 0
	_is_selecting = true
	_current_zoom_target = DEFAULT_ZOOM

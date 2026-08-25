@icon("res://addons/at-icons/node/layers.svg")
class_name DepthDetector
extends Node

@export var sprite_carrier: Node2D
@export var is_static: bool = true

@onready var sprite: Node2D = get_parent() as Node2D

func _ready() -> void:
	assert(sprite_carrier != null, "DEPTH DETECTOR: Sprite not set.")
	assert(sprite != null, "DEPTH DETECTOR: Sprite not set.")
	
	sprite.z_index = round(sprite_carrier.global_position.y)

func _physics_process(_delta: float) -> void:
	if is_static: return
	
	sprite.z_index =  round(sprite_carrier.global_position.y)

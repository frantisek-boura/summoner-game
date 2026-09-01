class_name Player
extends Entity

@export var camera: PlayerCamera
@export var minion_manager: MinionManager

@onready var movement: PlayerMovement = entity_movement as PlayerMovement
@onready var state_machine: PlayerStateMachine = entity_state_machine as PlayerStateMachine
@onready var health: EntityHealth = entity_health as EntityHealth

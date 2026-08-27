class_name Player
extends Entity

@export var minion_manager: MinionManager
@export var camera: PlayerCamera

var player_movement: PlayerMovement:
	get:
		return movement as PlayerMovement

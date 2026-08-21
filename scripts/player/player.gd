class_name Player
extends Entity

@export var minion_manager: MinionManager

var player_movement: PlayerMovement:
	get:
		return movement as PlayerMovement

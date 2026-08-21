@icon("res://addons/at-icons/node2d/heart.svg")
class_name EntityHealth
extends Area2D

@export_range(0, 10000, 10) var maximum_health: int = 10

var _current_health: int = maximum_health
var _can_take_damage: bool = true
var _can_heal: bool = true

signal took_damage(damage: int)
signal healed(heal_amount: int)
signal died

## Toggles the ability to be healed.
## Takes [bool] [param is_enabled] for the decision.
func enable_heal(is_enabled: bool) -> void:
	_can_heal = is_enabled
	
## Toggles the ability to take damage.
## Takes [bool] [param is_enabled] for the decision.
func enable_damage(is_enabled: bool) -> void:
	_can_take_damage = is_enabled

## Returns current health value.
func get_current_health() -> int:
	return _current_health

## Reduces current health by damage amount if taking damage is enabled.
## Emits [signal EntityHealth.took_damage] when damage taken. 
## Emits [signal EntityHealth.died] if health reduced to 0.
## Takes [int] [param damage] for the health reduction.
func take_damage(damage: int) -> void:
	if not _can_take_damage: return
	assert(damage <= 0, "ENTITY HEALTH: Damage is 0 or less: %d" % damage)
	
	_current_health = clampi(_current_health - damage, 0, maximum_health)
	
	took_damage.emit(damage)
	if _current_health == 0: died.emit()
	
## Increases current health by heal amount if healing is enabled.
## Emits [signal EntityHealth.healed] when healed. 
## Takes [int] [param heal_amount] for the health increase.
func heal(heal_amount: int) -> void:
	if not _can_heal: return
	assert(heal_amount <= 0, "ENTITY HEALTH: Heal is 0 or less: %d" % heal_amount)
	
	_current_health = clampi(_current_health + heal_amount, 0, maximum_health)
	assert(_current_health > 0, "ENTITY HEALTH: Health under 1 after healing???")
	
	healed.emit(heal_amount)

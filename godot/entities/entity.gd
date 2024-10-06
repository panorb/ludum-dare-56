class_name Entity
extends Node2D

var actual_position = Vector2(0, 0)
var target_position = Vector2(0, 0)

var _processed_tick : int = -1

func easing_function(x: float) -> float:
	return x

func update(delta: float, tick_time: float) -> void:
	position = actual_position + (target_position - actual_position) * easing_function((((1.0/SimulationState.TICKS_PER_SECOND)-tick_time)/(1.0/SimulationState.TICKS_PER_SECOND)))

func _step_internal(tick, x, y, items_future, entities_now, entities_future, level_structure):
	if tick > _processed_tick:
		step(x, y, items_future, entities_now, entities_future, level_structure)
		_processed_tick = tick

func is_free(x, y, entities_now, entities_future):
	return entities_now[y][x] == null and entities_future[y][x] == null

func step(x, y, items_future, entities_now, entities_future, level_structure):
	pass

func move_to(x, y, entities_future):
	entities_future[y][x] = self
	actual_position.x = position.x
	actual_position.y = position.y
	target_position.x = x*Globals.TILE_SIZE+(Globals.TILE_SIZE/2)
	target_position.y = y*Globals.TILE_SIZE+(Globals.TILE_SIZE)

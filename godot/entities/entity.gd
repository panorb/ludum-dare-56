class_name Entity
extends Node2D

var actual_position = Vector2(0, 0)
var target_position = Vector2(0, 0)

var _processed_tick : int = -1

var simulation_state : SimulationState = null

func set_simulation_state(simulation_state: SimulationState):
	self.simulation_state = simulation_state

func easing_function(x: float) -> float:
	return x

func update(delta: float, tick_time: float) -> void:
	var expected_tick_length = 1.0 / SimulationState.TICKS_PER_SECOND
	var progress = tick_time / expected_tick_length
	progress = max(0, min(1, progress))

	position = actual_position + (target_position - actual_position) * easing_function(progress)

func _step_internal(tick, x, y, items_future, entities_now, entities_future, level_structure):
	if tick > _processed_tick:
		step(x, y, items_future, entities_now, entities_future, level_structure)
		_processed_tick = tick

func is_free(x, y, entities_now, entities_future):
	return (entities_now[y][x] == null and entities_future[y][x] == null) 

func step(x, y, items_future, entities_now, entities_future, level_structure):
	pass

func spawn_item(x, y, items_future, item_type):
	items_future[y][x] = simulation_state.spawn_item(Vector2i(x, y), item_type)

func is_valid_lay_place():
	return false

func move_to(x, y, entities_future):
	entities_future[y][x] = self
	actual_position.x = position.x
	actual_position.y = position.y
	target_position.x = x*Globals.TILE_SIZE+(Globals.TILE_SIZE/2)
	target_position.y = y*Globals.TILE_SIZE+(Globals.TILE_SIZE)

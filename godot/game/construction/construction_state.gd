class_name ConstructionState
extends RefCounted

var _level = null
var _level_entities = []
var _level_items = []
var _player_entities = []
var _level_size = Vector2i(20, 12)

func create(level):
	_level = level
	_level_entities = []
	_level_items = []
	for entity in level.get_node("Entities").get_children():
		_level_entities.append(entity)
	for item in level.get_node("Items").get_children():
		_level_items.append(item)
	
	# TODO: Adjust as necessary
	var tilemap = level.get_node("TileMapLayer")
	_level_size = tilemap.get_used_rect().size

func create_simulation_state() -> SimulationState:
	var sim_state = SimulationState.new()
	sim_state.create(_level_size[0], _level_size[1], _level, _level_entities + _player_entities, _level_items)
	return sim_state

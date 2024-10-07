class_name SimulationState
extends Node2D

var items_now : Array # [[ BaseItem ]]
var entities_now : Array # [[ Entity ]]
var level_structure : Array # [[ int ]]

var tick_time = 0.0
var current_tick = 0

enum LEVEL_BLOCK { AIR = 0, WALL = 400 }

const TICKS_PER_SECOND = 4

func create(width, height, level, entities, items):
	items_now = _init_structure(width, height, true)
	entities_now = _init_structure(width, height)
	level_structure = _init_structure(width, height)
	
	# TODO: Adjust as necessary
	var tilemap = level.get_node("Structure")
	add_child(tilemap.duplicate())
	
	for entity in entities:
		var cloned_entity: Entity = entity.duplicate()
		# Bitte fragt mich niemals warum wir hier für die y-Position - 1 rechnen müssen... ICH WEISS ES NICHT! -P
		entities_now[int(entity.position.y / Globals.TILE_SIZE) - 1][int(entity.position.x / Globals.TILE_SIZE)] = cloned_entity
		cloned_entity.simulation_state = self
		add_child(cloned_entity)
	for item in items:
		var cloned_item = item.duplicate()
		# Bitte fragt mich niemals warum wir hier für die y-Position - 1 rechnen müssen... ICH WEISS ES NICHT! -P
		items_now[int(item.position.y / Globals.TILE_SIZE) - 1][int(item.position.x / Globals.TILE_SIZE)] = cloned_item
		cloned_item.simulation_state = self
		add_child(cloned_item)
	
	for tile_row in range(level_structure.size()):
		for tile_column in range(level_structure[tile_row].size()):
			level_structure[tile_row][tile_column] = LEVEL_BLOCK.AIR
			if tilemap.get_cell_source_id(Vector2i(tile_column, tile_row)) >= 0:
				level_structure[tile_row][tile_column] = LEVEL_BLOCK.WALL

func _init_structure(width: int, height: int, array: bool = false) -> Array:
	var res = []
	
	for j in range(height):
		var row = []
		for i in range(width):
			row.append(null)
		res.append(row)
	return res

func _process(delta: float) -> void:
	tick_time -= delta
	if tick_time < 0:
		step_forward()
		tick_time += (1.0/TICKS_PER_SECOND)
	
	for ticker in get_tree().get_nodes_in_group("tickers"):
		ticker.update(delta, tick_time)

func step_forward():
	var items_future : Array = _init_structure(items_now[0].size(), items_now.size(), true)
	var entities_future : Array = _init_structure(entities_now[0].size(), entities_now.size())
	
	for item_row_i in range(items_now.size()):
		for item_column_i in range(items_now[item_row_i].size()):
			var item = items_now[item_row_i][item_column_i]
			if item != null:
				item.step(item_column_i, item_row_i, items_now, items_future, level_structure)
	
	for entity_row_i in range(entities_now.size()):
		for entity_column_i in range(entities_now[entity_row_i].size()):
			var entity = entities_now[entity_row_i][entity_column_i]
			if entity != null:
				entity.step(entity_column_i, entity_row_i, items_future, entities_now, entities_future, level_structure)
	
	items_now = items_future
	entities_now = entities_future
	current_tick += 1

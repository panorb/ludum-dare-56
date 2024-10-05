class_name SimulationState
extends RefCounted

var items_now : Array # [[ Item ]]
var entities_now : Array # [[ Entity ]]
var level_structure : Array # [[ int ]]

enum LEVEL_BLOCK { AIR = 0, WALL = 400 }

func create(width, height, level, entities, items):
	items_now = _init_structure(width, height)
	entities_now = _init_structure(width, height)
	level_structure = _init_structure(width, height)
	
	# TODO: Adjust as necessary
	var tilemap = level.get_node("TileMapLayer")
	
	for entity in entities:
		#print(int(entity.position[0] / 16), " ", int(entity.position[1] / 16))
		entities_now[int(entity.position[1] / 16)][int(entity.position[0] / 16)] = entity
	for item in items:
		pass
	
	for tile_row in range(level_structure.size()):
		for tile_column in range(level_structure[tile_row].size()):
			level_structure[tile_row][tile_column] = LEVEL_BLOCK.AIR
			# TODO Adjust as necessary
			
			if tilemap.get_cell_source_id(Vector2i(tile_column, tile_row)) >= 0:
				level_structure[tile_row][tile_column] = LEVEL_BLOCK.WALL
	

func _init_structure(width: int, height: int) -> Array:
	var res = []
	
	for j in range(height):
		var row = []
		for i in range(width):
			row.append(null)
		res.append(row)
	return res

func step_forward():
	var items_future : Array = _init_structure(items_now[0].size(), items_now.size())
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

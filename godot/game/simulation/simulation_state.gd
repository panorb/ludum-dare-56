class_name SimulationState
extends Node

var items_now : Array[Array] # [[ Item ]]
var entities_now : Array[Array] # [[ Entity ]]
var level_structure : Array[Array] # [[ int ]]

enum LEVEL_BLOCK { AIR = 0, WALL = 400 }

func _init_structure(width: int, height: int) -> Array[Array]:
	var res = []
	
	for j in range(height):
		var row = []
		for i in range(width):
			row.append(null)
		res.append(row)
	return res

func step_forward():
	var items_future : Array[Array] = _init_structure(items_now[0].size(), items_now.size())
	var entities_future : Array[Array] = _init_structure(entities_now[0].size(), entities_now.size())
	
	for item_row_i in range(items_now.size()):
		for item_column_i in range(items_now[item_row_i].size()):
			var item = items_now[item_row_i][item_column_i]
			item.step(item_column_i, item_row_i, items_now, items_future)
	
	for entity_row_i in range(entities_now.size()):
		for entity_column_i in range(entities_now[entity_row_i].size()):
			var entity = items_now[entity_row_i][entity_column_i]
			entity.step(entity_column_i, entity_row_i, items_future, entities_now, entities_future)
	
	

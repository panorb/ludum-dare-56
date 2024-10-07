class_name ConstructionState
extends Node

var simulation_state = preload("res://game/simulation/simulation_state.tscn")

var _level = null
var _level_entities = []
var _level_items = []
var _player_entities = []
var _level_size = Vector2i(20, 12)

var base_item_scene : PackedScene = preload("res://items/base_item.tscn")

var _possible_entities = {
	"Carrier": preload("res://entities/carrier.tscn"),
	"Thrower": preload("res://entities/thrower.tscn"),
}

func create(level:LDTKLevel, left_top_position: Node2D, right_bottom_position: Node2D):
	_level = level
	_level_entities = []
	_level_items = []
	
	var entities_node = level.get_node("Entities")
	for entity_dict in entities_node.entities:
		var identifier = entity_dict["identifier"]
		
		match identifier:
			"Item":
				var item_type : String = entity_dict["fields"]["ItemType"].substr(9)
				var count = entity_dict["fields"]["Count"]
				
				print("Item " + str(item_type) + " x " + str(count))
				var item_node : BaseItem = base_item_scene.instantiate()
				item_node.position = Vector2(entity_dict.position) + Vector2(0.5, 1) * Globals.TILE_SIZE
				item_node.item_type = BaseItem.ITEM_TYPE.get(item_type)
				item_node.count = count
				
				level.get_node("Entities").add_child(item_node)
				_level_items.append(item_node)
			_:
				var entity_scene : PackedScene = _possible_entities[identifier]
				var entity_node : Entity = entity_scene.instantiate()
				entity_node.position = Vector2(entity_dict.position) + Vector2(0.5, 1) * Globals.TILE_SIZE
				level.get_node("Entities").add_child(entity_node)
				_level_entities.append(entity_node)
	
	#for entity in level.get_node("Entities").get_children():
	#	_level_entities.append(entity)
	#for item in level.get_node("Items").get_children():
	#	_level_items.append(item)
	
	# TODO: Adjust as necessary
	var tilemap = level.get_node("Structure")
	
	_level_size = tilemap.get_used_rect().size
	
	# Calculate distance of left top node and right bottom node for scale
	var level_scale: float = left_top_position.position.distance_to(right_bottom_position.position)
	
	add_child(level)

func create_simulation_state(debug_mode: bool = false) -> SimulationState:
	var sim_state:SimulationState = simulation_state.instantiate()
	sim_state.create(_level_size[0], _level_size[1], _level, _level_entities + _player_entities, _level_items, debug_mode)
	return sim_state

extends Entity

var recipes = {
	BaseItem.ITEM_TYPE.HONEYCOMBS: BaseItem.ITEM_TYPE.HONEY_ESSENCE,
	BaseItem.ITEM_TYPE.SAPHIRE: BaseItem.ITEM_TYPE.SAPHIRE_ESSENCE,
	BaseItem.ITEM_TYPE.CHICKEN_FOOT: BaseItem.ITEM_TYPE.CHICKEN_ESSENCE,
	BaseItem.ITEM_TYPE.BEETLE: BaseItem.ITEM_TYPE.BEETLE_ESSENCE,
	BaseItem.ITEM_TYPE.POMEGRANATE: BaseItem.ITEM_TYPE.POMEGRANATE_ESSENCE,
	BaseItem.ITEM_TYPE.HONEY: BaseItem.ITEM_TYPE.MEAD,
	BaseItem.ITEM_TYPE.SAPHIRE_DUST: BaseItem.ITEM_TYPE.JEWEL_JUICE,
	BaseItem.ITEM_TYPE.POMEGRANATE_ESSENCE:  BaseItem.ITEM_TYPE.POMEGRANATE_LIQUEUR
}

func _ready() -> void:
	# pass # Replace with function body.
	target_position = position
	actual_position = position

func step(x, y, items_future, entities_now, entities_future, level_structure):
	if items_future[y][x] != null and recipes.has(items_future[y][x].item_type):
		items_future[y][x].item_type = recipes[items_future[y][x].item_type]
	
	move_to(x, y, entities_future)

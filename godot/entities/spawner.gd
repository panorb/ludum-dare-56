extends Entity


func _ready() -> void:
	# pass # Replace with function body.
	target_position = position
	actual_position = position

func step(x, y, items_future, entities_now, entities_future, level_structure):
	#if items_future[y][x] == null:
	#	items_future[y][x].item_type = recipes[items_future[y][x].item_type]
	if items_future[y][x] == null and items_future[y + 1][x] == null :
		spawn_item(x, y, items_future, BaseItem.ITEM_TYPE.FROG)
	# items_future[y][x] = items_now[y][x]
	
	move_to(x, y, entities_future)

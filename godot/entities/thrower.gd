extends Entity

func _ready() -> void:
	# pass # Replace with function body.
	target_position = position
	actual_position = position

func step(x, y, items_future, entities_now, entities_future, level_structure):
	if items_future[y][x] != null:
		var item:BaseItem = items_future[y][x]
		if item.count == 1:
			items_future[y][x] = null
			items_future[y][x+1] = item
			item.throw()
		else:
			item.count -= 1
			items_future[y][x] = item
			var thrown_item = item.clone()
			thrown_item.count = 1
			thrown_item.actual_position = actual_position
			thrown_item.actual_position.x += 1
			items_future[y][x+1] = thrown_item
			thrown_item.throw();
	move_to(x, y, entities_future)

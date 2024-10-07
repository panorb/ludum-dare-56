extends Entity

func _ready() -> void:
	# pass # Replace with function body.
	target_position = position
	actual_position = position

func step(x, y, items_future, entities_now, entities_future, level_structure):
	if items_future[y][x] != null:
		var item:BaseItem = items_future[y][x]
		if item.count == 1:
			item.actual_position.y -= 1
			item.position.y -= 1
			items_future[y-1][x] = item
			items_future[y][x] = null
			item.throw()
		elif item.count > 1:
			item.count -= 1
			var thrown_item = item.clone()
			thrown_item.count = 1
			thrown_item.actual_position.y -= 1
			thrown_item.position.y -= 1
			items_future[y-1][x] = thrown_item
			thrown_item.throw();
	
	move_to(x, y, entities_future)

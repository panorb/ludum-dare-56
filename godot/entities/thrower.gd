extends Entity

func _ready() -> void:
	# pass # Replace with function body.
	target_position = position
	actual_position = position

func step(x, y, items_future, entities_now, entities_future, level_structure):
	if items_future[y][x] != null:
		var item = items_future[y][x]
		item.throw()
	move_to(x, y, entities_future)

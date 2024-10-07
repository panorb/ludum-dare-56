extends Entity


func _ready() -> void:
	# pass # Replace with function body.
	target_position = position
	actual_position = position

func is_valid_lay_place():
	return true

func step(x, y, items_future, entities_now, entities_future, level_structure):
	if items_future[y][x] != null:
		items_future[y][x].queue_free()
	
	move_to(x, y, entities_future)

extends Entity

var direction = -1


func _ready() -> void:
	# pass # Replace with function body.
	target_position.x = position.x
	target_position.y = position.y
	actual_position.x = position.x
	actual_position.y = position.y

func step(x, y, items_future, entities_now, entities_future, level_structure):
	var next_x = x+direction
	if is_free(next_x, y, entities_now, entities_future) and level_structure[y][next_x] == SimulationState.LEVEL_BLOCK.AIR && level_structure[y+1][next_x] == SimulationState.LEVEL_BLOCK.WALL:
		move_to(next_x, y, entities_future)
	else:
		move_to(x, y, entities_future)
		direction *= -1
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

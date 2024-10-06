extends ItemState

var target_position = Vector2(0, 0)

func initialize(item: Item):
	target_position = item.actual_position
	super(item)

func easing_function(x: float) -> float:
	return x

func step(x, y, items_now, items_future, level_structure):
	if (level_structure[y+1][x] == SimulationState.LEVEL_BLOCK.AIR and level_structure[y+2][x] == SimulationState.LEVEL_BLOCK.AIR):
		move_to(x, y+2, items_future)
	elif level_structure[y+1][x] == SimulationState.LEVEL_BLOCK.AIR:
		move_to(x, y+1, items_future)
	else:
		move_to(x, y, items_future)

func move_to(x, y, items_future):
	item.actual_position = item.position
	target_position = Vector2(x + 0.5, y + 0.5) * Globals.TILE_SIZE
	
	if item.actual_position != target_position:
		if item.tween.is_running():
			item.tween.kill()
		
		item.position = item.actual_position
		item.tween = get_tree().create_tween()
		item.tween.tween_property(item, "position", target_position, 1.0 / SimulationState.TICKS_PER_SECOND)
		if item.tween.is_valid():
			item.tween.play()
	
	super(x, y, items_future)

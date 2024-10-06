extends ItemState

var direction = -1
var target_position = Vector2(0, 0)

func initialize(item: Item):
	super(item)

func enter():
	target_position = item.actual_position

func easing_function(x: float) -> float:
	return x

#func update(delta: float, tick_time: float) -> void:
#	item.position = item.actual_position + (target_position - item.actual_position) * easing_function((((1.0/SimulationState.TICKS_PER_SECOND)-tick_time)/(1.0/SimulationState.TICKS_PER_SECOND)))
#	
#	if item.position == item.actual_position:
#		done.emit()
#	# item.position = item.actual_position + (item.target_position - item.actual_position) * easing_function((((1.0/SimulationState.TICKS_PER_SECOND)-tick_time)/(1.0/SimulationState.TICKS_PER_SECOND)))

func step(x, y, items_now, items_future, level_structure):
	if x+3 < level_structure[0].size() && level_structure[y-1][x+3] == SimulationState.LEVEL_BLOCK.AIR:
		move_to(x+3, y-1, items_future)
	else:
		move_to(x, y, items_future)
	
	done.emit()
	

func move_to(x, y, items_future):
	item.actual_position = item.position
	target_position = Vector2(x + 0.5, y + 0.5) * Globals.TILE_SIZE
	
	# var tween : Tween = item.tween
	item.tween.kill()
	item.tween = get_tree().create_tween()
	item.tween.tween_property(item, "position", target_position, 1.0 / SimulationState.TICKS_PER_SECOND)
	item.tween.play()
	super(x, y, items_future)
	#if (level_structure[y+1][x] == SimulationState.LEVEL_BLOCK.AIR and level_structure[y+2][x] == SimulationState.LEVEL_BLOCK.AIR):
	#	move_to(x, y+2, items_future)
	#elif level_structure[y+1][x] == SimulationState.LEVEL_BLOCK.AIR:
	#	move_to(x, y+1, items_future)
	#else:
	#	move_to(x, y, items_future)

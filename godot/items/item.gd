class_name Item
extends Node2D

var _processed_tick : int = -1
var actual_position = Vector2(0, 0)
@onready var tween : Tween = get_tree().create_tween()

func update(delta: float, tick_time: float) -> void:
	pass

func _step_internal(tick, x, y, items_now, items_future, level_structure):
	if tick > _processed_tick:
		step(x, y, items_now, items_future, level_structure)
		_processed_tick = tick
	else:
		print("Skipped!")

func step(x, y, items_now, items_future, level_structure):
	pass

func move_to(x, y, items_future):
	# items_future[y][x] = self
	items_future[y][x].append(self)
	
	# actual_position.x = position.x
	#actual_position.y = position.y
	#target_position.x = x*Globals.TILE_SIZE+(Globals.TILE_SIZE/2)
	# target_position.y = y*Globals.TILE_SIZE+(Globals.TILE_SIZE/2)

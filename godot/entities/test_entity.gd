extends Entity

var direction = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func step(x, y, items_future, entities_now, entities_future, level_structure):
	# TODO Test this
	#entities_future[y][x] = self
	var next_x = x+direction
	if level_structure[y][next_x] == SimulationState.LEVEL_BLOCK.AIR && level_structure[y+1][next_x] == SimulationState.LEVEL_BLOCK.WALL:
		entities_future[y][next_x] = self
		position.x = next_x*16+8
		position.y = y*16+8
	else:
		entities_future[y][x] = self
		direction *= -1

extends Entity

var direction = -1
var actual_position = Vector2(0, 0)
var target_position = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.

func easing_function(x: float) -> float:
	return x

func _ready() -> void:
	# pass # Replace with function body.
	target_position.x = position.x
	target_position.y = position.y
	actual_position.x = position.x
	actual_position.y = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float, tick_time: float) -> void:
	#position += (target_position - position).normalized() * speed * Game.TICKS_PER_SECOND * delta
	position = actual_position + (target_position - actual_position) * easing_function((((1.0/SimulationState.TICKS_PER_SECOND)-tick_time)/(1.0/SimulationState.TICKS_PER_SECOND)))

func step(x, y, items_future, entities_now, entities_future, level_structure):
	var next_x = x+direction
	if level_structure[y][next_x] == SimulationState.LEVEL_BLOCK.AIR && level_structure[y+1][next_x] == SimulationState.LEVEL_BLOCK.WALL:
		entities_future[y][next_x] = self
		actual_position.x = position.x
		actual_position.y = position.y
		target_position.x = next_x*16+8
		target_position.y = y*16+8
	else:
		entities_future[y][x] = self
		direction *= -1
		actual_position.x = position.x
		actual_position.y = position.y

extends Item

@onready var current_state : ItemState = $States/StateNormal
@onready var states = $States

func easing_function(x:
	 float) -> float:
	return x

func _ready() -> void:
	actual_position = position
	
	for state in states.get_children():
		state.initialize(self)
		state.done.connect(_on_state_done)
	

func _on_state_done():
	current_state = $States/StateNormal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float, tick_time: float) -> void:
	current_state.update(delta, tick_time)
	#position += (target_position - position).normalized() * speed * Game.TICKS_PER_SECOND * delta
	# position = actual_position + (target_position - actual_position) * easing_function((((1.0/SimulationState.TICKS_PER_SECOND)-tick_time)/(1.0/SimulationState.TICKS_PER_SECOND)))

func step(x, y, items_now, items_future, level_structure):
	current_state.step(x, y, items_now, items_future, level_structure)
	
func throw():
	current_state = $States/StateThrown
	current_state.enter()
	
	# current_state.initialize(self)

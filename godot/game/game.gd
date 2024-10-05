class_name Game extends Node

signal show_lose_screen
signal show_win_screen

var level_test = preload("res://levels/test_level.tscn")

var current_level = null
var construction_state = null
var simulation_state = null
var tick_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	load_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tick_time -= delta
	if simulation_state != null and tick_time < 0:
		simulation_state.step_forward()
		tick_time = 0.25
	if Input.is_action_just_pressed("ui_select"):
		#print(get_viewport().get_mouse_position())
		start_simulation()

func start_level(level: int):
	# pass
	# TODO create & load level scene
	if current_level != null:
		current_level.queue_free()
	# TODO Instantiate correct level
	current_level = level_test.instantiate()
	add_child(current_level)
	# TODO create construction state
	construction_state = ConstructionState.new()
	construction_state.create(current_level)

func start_simulation():
	simulation_state = construction_state.create_simulation_state()

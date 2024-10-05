class_name Game extends Node

signal show_lose_screen
signal show_win_screen

var level_test = preload("res://levels/test_level.tscn")

var current_level = null
var construction_state = null
var simulation_state = null
var tick_time = 0.0
var running = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	start_level(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tick_time -= delta
	if simulation_state != null and tick_time < 0:
		simulation_state.step_forward()
		tick_time = 0.25
	if Input.is_action_just_pressed("ui_select"):
		#print(get_viewport().get_mouse_position())
		if not running:
			start_simulation()
		else:
			stop_simulation()

func start_level(level: int):
	if current_level != null:
		current_level.queue_free()
	# TODO Instantiate correct level
	if level:
		current_level = level_test.instantiate()
	construction_state = get_node("ConstructionState")
	construction_state.create(current_level)

func start_simulation():
	construction_state.hide()
	if simulation_state != null:
		simulation_state.queue_free()
	simulation_state = construction_state.create_simulation_state()
	add_child(simulation_state)
	running = true

func stop_simulation():
	construction_state.show()
	simulation_state.queue_free()
	running = false

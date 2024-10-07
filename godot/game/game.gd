class_name Game extends Node

signal show_lose_screen
signal show_win_screen


var base_levels : Array[PackedScene] = []

var debug_mode: bool = true

var current_level: LDTKLevel = null
var construction_state: ConstructionState = null
var simulation_state: SimulationState = null
var running: bool = false

@onready var level_left_top := %LevelLeftTopNode2D
@onready var level_right_bottom :=  %LevelRightBottomNode2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for level_file in DirAccess.get_files_at("res://game/levels"):
		base_levels.append(load("res://game/levels/" + level_file))
	start_level(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
		current_level = base_levels[level-1].instantiate()
	construction_state = get_node("ConstructionState")
	construction_state.create(current_level, level_left_top, level_right_bottom)
	
	

func start_simulation():
	construction_state.hide()
	if simulation_state != null:
		simulation_state.queue_free()
	simulation_state = construction_state.create_simulation_state(debug_mode)
	simulation_state.scale = construction_state.scale
	add_child(simulation_state)
	running = true

func stop_simulation():
	construction_state.show()
	simulation_state.queue_free()
	running = false

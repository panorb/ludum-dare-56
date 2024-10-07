class_name Game extends Node

signal show_lose_screen
signal show_win_screen


var base_levels : Array[PackedScene] = []

var debug_mode: bool = true

var current_level: LDTKLevel = null
var simulation_state = null
var running: bool = false

@onready var level_left_top := %LevelLeftTopNode2D
@onready var level_right_bottom :=  %LevelRightBottomNode2D

var to_be_delivered : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%SelectBoard.entity_pressed.connect(self._on_entity_pressed)
	for level_file in DirAccess.get_files_at("res://game/levels"):
		base_levels.append(load("res://game/levels/" + level_file))
	# start_level(1)

func _on_level_constraints_update(item_target_counts: Array, entity_available_counts: Array, additional_info: String):
	print("Additional Info:  " + additional_info)
	to_be_delivered = item_target_counts
	%GroceryList.update_witch_note(item_target_counts, additional_info)

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
	
	# TODO take everything from $Construction/Entities and copy it into $Simulation/Entities
	

func start_simulation():
	# TODO implement
	running = true

func stop_simulation():
	# TODO implement
	running = false

func _on_entity_pressed(entity_name: String):
	if self.current_selected_entity_name == entity_name:
		self.current_selected_entity_name = ''
	else:
		self.current_selected_entity_name = entity_name

	# TODO implement

class_name Item
extends Node2D

@export var color1:Vector3i
@export var color2:Vector3i
@export var speed_factor: float = 2
var _processed_tick : int = -1
var actual_position = Vector2(0, 0)
@onready var tween : Tween = get_tree().create_tween()

@onready var shader:ShaderMaterial = get_node("%Texture").material as ShaderMaterial

func _process(delta: float) -> void:
	pass
	## Demo für Farbveränderungsshader mittels Godot Code
	#var time = Time.get_unix_time_from_system()
	#var factor = speed_factor;
	#var hue_a = fmod(float(time) * factor, 2.0);
	#var hue_b = fmod(float(time) * factor + 0.5, 2.0);
	
	#var color_a = Color.from_hsv(hue_a, 1.0, 1.0);
	#var color_b = Color.from_hsv(hue_b, 1.0, 1.0);
	#var color_a_vec = Vector3(color_a.r, color_a.g, color_a.b);
	#var color_b_vec = Vector3(color_b.r, color_b.g, color_b.b);
	
	# selben namen wie im shader code
	#shader.set_shader_parameter("new_color_a", color_a_vec);
	#shader.set_shader_parameter("new_color_b", color_b_vec);

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

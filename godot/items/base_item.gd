class_name BaseItem
extends Item

@onready var current_state : ItemState = $States/StateNormal
@onready var states = $States

enum ITEM_TYPE { HONEYCOMBS, SAPHIRE, FROG, CHICKEN_FOOT, BEETLE, POMEGRANATE, HONEY, SAPHIRE_DUST,
	POMEGRANATE_SEEDS, HONEY_ESSENCE, SAPHIRE_ESSENCE, FROG_ESSENCE, CHICKEN_ESSENCE, BEETLE_ESSENCE,
	POMEGRANATE_ESSENCE, MEAD, JEWEL_JUICE, POMEGRANATE_LIQUEUR }

@export var item_type : ITEM_TYPE = ITEM_TYPE.HONEYCOMBS
@export var count : int = 1

@onready var sprite_container : Node2D = $Sprites

func update_displayed_item():
	var texture_region : Rect2i
	
	print(item_type)
	if item_type <= ITEM_TYPE.POMEGRANATE_SEEDS: # Sprites
		texture_region = Rect2i(item_type * 32, 0, 32, 32)
	elif item_type <= ITEM_TYPE.POMEGRANATE_ESSENCE: # Thick flasks
		pass
	else: # Thin flasks
		pass
	
	for i in range(5):
		var sprite_node : Sprite2D = sprite_container.get_node("Sprite" + str(i + 1))
		if i >= count:
			sprite_node.visible = false
		sprite_node.region_rect = texture_region

func easing_function(x: float) -> float:
	return x

func _process(delta: float) -> void:
	update_displayed_item()

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

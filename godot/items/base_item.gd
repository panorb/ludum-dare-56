class_name BaseItem
extends Item

@onready var current_state : ItemState = $States/StateNormal
@onready var states = $States

var simulation_state : SimulationState

enum ITEM_TYPE { HONEYCOMBS, SAPHIRE, FROG, CHICKEN_FOOT, BEETLE, POMEGRANATE, HONEY, SAPHIRE_DUST,
	POMEGRANATE_SEEDS, HONEY_ESSENCE, SAPHIRE_ESSENCE, FROG_ESSENCE, CHICKEN_ESSENCE, BEETLE_ESSENCE,
	POMEGRANATE_ESSENCE, MEAD, JEWEL_JUICE, POMEGRANATE_LIQUEUR }

@export var item_type : ITEM_TYPE = ITEM_TYPE.HONEYCOMBS
@export var count : int = 1

@onready var sprite_container : Node2D = $Sprites

@export var never_free : bool = false

func update_displayed_item():
	var texture_region := Rect2i(item_type * 32, 0, 32, 32)
	
	for i in range(5):
		var sprite_node : Sprite2D = sprite_container.get_node("Sprite" + str(i + 1))
		if i >= count:
			sprite_node.visible = false
		sprite_node.region_rect = texture_region
	
	if not never_free and count == 0:
		queue_free()

func easing_function(x: float) -> float:
	return x

func _process(delta: float) -> void:
	update_displayed_item()

func _ready() -> void:
	actual_position = position
	
	for state in states.get_children():
		state.initialize(self)
		state.done.connect(_on_state_done)
func clone() -> BaseItem:
	# use preload.instance() to create a new instance of this item
	var new_item = preload("res://items/base_item.tscn").instantiate()
	self.simulation_state.add_child(new_item)

	new_item.item_type = item_type
	new_item.count = count
	new_item.current_state = new_item.states.get_node("StateNormal")
	new_item.simulation_state = simulation_state
	new_item.actual_position = actual_position
	new_item.position = self.position

	return new_item

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

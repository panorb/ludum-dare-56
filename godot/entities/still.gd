extends Entity

const RESULT_STEPS := 4

var recipes = {
	BaseItem.ITEM_TYPE.HONEYCOMBS: BaseItem.ITEM_TYPE.HONEY_ESSENCE,
	BaseItem.ITEM_TYPE.SAPHIRE: BaseItem.ITEM_TYPE.SAPHIRE_ESSENCE,
	BaseItem.ITEM_TYPE.CHICKEN_FOOT: BaseItem.ITEM_TYPE.CHICKEN_ESSENCE,
	BaseItem.ITEM_TYPE.FROG: BaseItem.ITEM_TYPE.FROG_ESSENCE,
	BaseItem.ITEM_TYPE.BEETLE: BaseItem.ITEM_TYPE.BEETLE_ESSENCE,
	BaseItem.ITEM_TYPE.POMEGRANATE: BaseItem.ITEM_TYPE.POMEGRANATE_ESSENCE,
	BaseItem.ITEM_TYPE.HONEY: BaseItem.ITEM_TYPE.MEAD,
	BaseItem.ITEM_TYPE.SAPHIRE_DUST: BaseItem.ITEM_TYPE.JEWEL_JUICE,
	BaseItem.ITEM_TYPE.POMEGRANATE_ESSENCE:  BaseItem.ITEM_TYPE.POMEGRANATE_LIQUEUR
}

var current_item_typ = null
var current_item_steps = null

func _ready() -> void:
	# pass # Replace with function body.
	target_position = position
	actual_position = position

func step(x, y, items_future, entities_now, entities_future, level_structure):
	if self.current_item_typ != null:
		if self.current_item_steps <= 0:
			%ProducingAudioStreamPlayer.play()
			var spawning_item_type = self.recipes[self.current_item_typ]
			self.spawn_item(x+1, y, items_future, spawning_item_type)
			self.current_item_steps = RESULT_STEPS
			self.current_item_typ = null
		else:
			self.current_item_steps = self.current_item_steps - 1
	else:
		var handling_item = items_future[y][x]
		if handling_item != null:
			var handling_item_type = handling_item.item_type
			var can_use_item = recipes.has(handling_item_type)
			if can_use_item:
				%WorkingAudioStreamPlayer.play()
				self.current_item_typ = handling_item_type
				self.current_item_steps = 4
			handling_item.queue_free()
	move_to(x, y, entities_future)

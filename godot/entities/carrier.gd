extends Entity

var direction = -1

func _ready() -> void:
	# pass # Replace with function body.
	target_position.x = position.x
	target_position.y = position.y
	actual_position.x = position.x
	actual_position.y = position.y

func step(x, y, items_future, entities_now, entities_future, level_structure):
	var next_x = x+direction
	
	if items_future[y][x] != null and pickup(items_future[y][x]):
		items_future[y][x].queue_free()
		items_future[y][x] = null
	
	var other_entity : Entity = entities_now[y][next_x]
	if other_entity == null:
		other_entity = entities_future[y][next_x]
	
	if other_entity != null and other_entity.is_valid_lay_place():
		spawn_item(next_x, y, items_future, $CarriedItem.item_type)
		$CarriedItem.visible = false
	
	if other_entity != null  \
		and direction == 1 \
		and $CarriedItem.visible \
		and other_entity.has_method("swap"):
		other_entity.swap($CarriedItem, self, false)
	
	if is_free(next_x, y, entities_now, entities_future) and level_structure[y][next_x] == SimulationState.LEVEL_BLOCK.AIR && level_structure[y+1][next_x] == SimulationState.LEVEL_BLOCK.WALL:
		move_to(next_x, y, entities_future)
	else:
		move_to(x, y, entities_future)
		direction *= -1
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

func pickup(item):
	if $CarriedItem.visible:
		return false
	$CarriedItem.visible = true
	$CarriedItem.item_type = item.item_type
	
	%PickupAudioStreamPlayer.play()
	
	return true

func swap(item_to_receive, other_swapper, initiated_on_this_entity:bool):
	if initiated_on_this_entity:
		var item_to_send = {
			item_type = $CarriedItem.item_type,
			visible = $CarriedItem.visible
		}

		pickup(item_to_receive)

		if item_to_send.visible:
			return item_to_send
		else:
			return null
	else:
		var item_received = other_swapper.swap($CarriedItem, self, true)
		pickup(item_received)

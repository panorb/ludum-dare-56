extends Control

@onready var grocery_item_scene : PackedScene = preload("res://gui/grocery_item.tscn")
@onready var grocery_items_container : VBoxContainer = %GroceryItems

func update_witch_note(item_target_counts: Array, additional_info: String):
	%AdditionalInfoLabel.text = additional_info
	
	for child in grocery_items_container.get_children():
		child.queue_free()
	
	for i in range(BaseItem.ITEM_TYPE.keys().size()):
		if item_target_counts[i] > 0:
			var node = grocery_item_scene.instantiate()
			node.item_type = i
			node.count = item_target_counts[i]
			grocery_items_container.add_child(node)

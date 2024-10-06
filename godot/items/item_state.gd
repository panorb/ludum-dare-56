class_name ItemState
extends Node

var item

signal done

func initialize(item: Item):
	self.item = item

func update(delta: float, tick_time: float) -> void:
	pass

func step(x, y, items_now, items_future, level_structure):
	pass

func move_to(x, y, items_future):
	item.move_to(x, y, items_future)

class_name ThrowerCard extends TextureRect

signal pressed

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		self.pressed.emit()

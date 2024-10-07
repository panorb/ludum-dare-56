class_name EntityCard extends CenterContainer

signal pressed

@export var entity_name: String
@export var entity_texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%EntityLabel.text = entity_name
	%EntityTextureRect.texture = entity_texture

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		self.pressed.emit(entity_name)
	

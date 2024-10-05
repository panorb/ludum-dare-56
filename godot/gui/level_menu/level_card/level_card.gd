@tool
class_name LevelCard extends AspectRatioContainer

signal pressed

const UNLOCK_MODULATE = Color.WHITE
const UNLOCK_MOUSE_CURSOR_SHAPE = CursorShape.CURSOR_POINTING_HAND

const LOCK_MODULE = Color.GRAY
const LOCK_MOUSE_CURSOR_SHAPE = CursorShape.CURSOR_FORBIDDEN

@onready var level_name_label = %LevelNameLabel
@onready var level_texture_rect = %LevelTextureRect

@export var level: int

@export var level_name: String:
	get: return self._level_name
	set(value):
		self._level_name = value
		if level_name_label:
			level_name_label.text = value

@export var level_texture: Texture2D:
	get: return self._level_texture
	set(value):
		self._level_texture = value
		if level_texture_rect:
			self._level_texture = value

@export var locked: bool:
	get: return self._locked
	set(value):
		self._locked = value
		if value:
			self.modulate = LOCK_MODULE
			self.mouse_default_cursor_shape = LOCK_MOUSE_CURSOR_SHAPE
		else:
			self.modulate = UNLOCK_MODULATE
			self.mouse_default_cursor_shape = UNLOCK_MOUSE_CURSOR_SHAPE

var _level_name: String
var _level_texture: Texture2D 
var _locked: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.level_name_label.text = self._level_name
	self.level_texture = self.level_texture

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		self.pressed.emit(self.level, self.locked)

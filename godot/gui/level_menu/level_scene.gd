class_name LevelScene extends Control

@onready var level_code_button := %LevelCodeButton
@onready var level_code_line_edit := %LevelCodeLineEdit

@onready var level_codes: Dictionary = {
	'1': 1,
	'2': 2,
}

@onready var unlocked_level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_code_button.pressed.connect(_on_process_level_code)
	level_code_line_edit.text_submitted.connect(_on_process_level_code)

func _on_process_level_code():
	var level_code: String = self.level_code_line_edit.text
	if level_code in self.level_codes:
		var level: int = self.level_codes[level_code]
		self.unlocked_level = level

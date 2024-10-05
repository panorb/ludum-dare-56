class_name LevelScene extends Control

@onready var level_code_button := %LevelCodeButton
@onready var level_code_line_edit := %LevelCodeLineEdit

@onready var level_cards := [ %LevelCard1, %LevelCard2, %LevelCard3 ]

@onready var level_codes: Dictionary = {
	'1': 1,
	'2': 2,
	'3': 3,
}

@onready var unlocked_level: int = 0

signal level_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_code_button.pressed.connect(_on_process_level_code)
	level_code_line_edit.text_submitted.connect(_on_process_level_code)

	for level_card: LevelCard in level_cards:
		level_card.pressed.connect(_on_level_selected)
		level_card.locked = level_card.level > self.unlocked_level

func _on_level_selected(level: int) -> void:
	if level <= unlocked_level:
		level_selected.emit(level)

func _on_process_level_code():
	var level_code: String = self.level_code_line_edit.text
	if level_code in self.level_codes:
		var level: int = self.level_codes[level_code]
		self.unlocked_level = maxi(level, self.unlocked_level)
		for level_card in level_cards:
			level_card.locked = level_card.level > self.unlocked_level

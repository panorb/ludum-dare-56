class_name LevelScene extends Control

@onready var level_code_button := %LevelCodeButton
@onready var level_code_line_edit := %LevelCodeLineEdit

@onready var level_cards := [ %LevelCard1, %LevelCard2, %LevelCard3 ]

@onready var level_codes: Dictionary = {
	'1': 1,
	'2': 2,
	'3': 3,
}

signal level_selected
signal locked_level_selected
signal unlock_level_till

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_code_button.pressed.connect(_on_process_level_code)
	level_code_line_edit.text_submitted.connect(_on_process_level_code)

	for level_card: LevelCard in level_cards:
		level_card.pressed.connect(_on_level_selected)

func unlock_level(level: int):
	for level_card in level_cards:
		level_card.locked = level_card.level > level

func _on_level_selected(level: int) -> void:
	level_selected.emit(level)

func _on_process_level_code():
	var level_code: String = self.level_code_line_edit.text
	if level_code in self.level_codes:
		var unlocking_level: int = self.level_codes[level_code]
		unlock_level_till.emit(unlocking_level)

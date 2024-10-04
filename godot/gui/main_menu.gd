class_name MainMenu extends Control

signal start_game

@onready var start_button := %StartButton

func _ready() -> void:
	start_button.pressed.connect(func():start_game.emit());

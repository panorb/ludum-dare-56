class_name MainMenu extends Control

signal start_game
signal change_language

@onready var start_button := %StartButton
@onready var credits_button := %CreditsButton
@onready var quit_button := %QuitButton
@onready var select_english_button := %SelectEnglishButton
@onready var select_german_button := %SelectGermanButton

func _ready() -> void:
	start_button.pressed.connect(func(): start_game.emit());
	select_english_button.pressed.connect(func(): change_language.emit('en'))
	select_german_button.pressed.connect(func(): change_language.emit('de'))

	# Web do not support quite
	if OS.has_feature('web'):
		quit_button.visible = false
	else:
		quit_button.pressed.connect(func(): get_tree().quit())

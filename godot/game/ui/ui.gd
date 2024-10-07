class_name Ui extends Control

signal entity_pressed

const THROWER_ID := "Thrower"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ThrowerTextureRect.pressed.connect(func(): entity_pressed.emit(THROWER_ID))

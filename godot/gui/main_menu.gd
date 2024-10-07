class_name MainMenu extends Control

signal show_levels
signal change_language
signal sfx_value_changed
signal music_value_changed
signal show_credits

@onready var level_button := %LevelButton
@onready var credits_button := %CreditsButton
@onready var quit_button := %QuitButton

@onready var select_english_button := %SelectEnglishButton
@onready var select_german_button := %SelectGermanButton

@onready var sfx_sound_slider := %SfxSoundSlider
@onready var sfx_sound_percent_label := %SfxSoundPercentLabel

@onready var music_sound_slider := %MusicSoundSlider
@onready var music_sound_percent_label := %MusicSoundPercentLabel

func _ready() -> void:
	level_button.pressed.connect(_emit_show_levels);
	%CreditsButton.pressed.connect(func(): show_credits.emit())
	select_english_button.pressed.connect(func(): change_language.emit('en'))
	select_german_button.pressed.connect(func(): change_language.emit('de'))
	
	# Web do not support quite
	if OS.has_feature('web'):
		quit_button.visible = false
	else:
		quit_button.pressed.connect(func(): get_tree().quit())

	sfx_sound_slider.value_changed.connect(func(volume_value: float): _emit_volume_changed(sfx_value_changed, volume_value))
	music_sound_slider.value_changed.connect(func(volume_value: float): _emit_volume_changed(music_value_changed, volume_value))

func _emit_show_levels():
	self.show_levels.emit()

func _emit_volume_changed(volume_signal: Signal, volume_percent: float):
	volume_signal.emit(volume_percent)
	
func set_music_volume(volume_percent: float):
	_set_volume(volume_percent, music_sound_slider, music_sound_percent_label)
	
func set_sfx_volume(volume_percent: float):
	_set_volume(volume_percent, sfx_sound_slider, sfx_sound_percent_label)

func _set_volume(volume_percent: float, slider_node: Slider, label_node: Label ):
	slider_node.set_value_no_signal(volume_percent)
	label_node.text = '%d %%' % volume_percent

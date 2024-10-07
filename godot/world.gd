extends Node

const MAIN_MENU_SCENE := 'main_menu'
const GAME_SCENE := 'game'
const LEVEL_SCENE := 'level'
const LOSE_SCENE := 'lose'
const WIN_SCENE := 'win'
const CREDITS_SCENE := 'credits'

const LANGUAGE_ENGLISH := 'en'
const LANGUAGE_GERMAN := 'de'

const SFX_SOUND_BUS := 'SFX'
const MUSIC_SOUND_BUS := 'Music'

const FAST_MUSIC_LEVEL := 2

@onready var main_background_theme_audio_stream_player := %MainBackgroundThemeAudioStreamPlayer
@onready var main_background_theme_fast_audio_stream_player := %MainBackgroundThemeFastAudioStreamPlayer

var scenes : Dictionary = {
	MAIN_MENU_SCENE: preload('res://gui/main_menu.tscn'),
	GAME_SCENE: preload('res://game/game.tscn'),
	LEVEL_SCENE: preload('res://gui/level_menu/level_scene.tscn'),
	CREDITS_SCENE: preload("res://gui/credits/credits.tscn"),
	LOSE_SCENE: null, #preload('res://gui/end_screen/lose/lose_screen.tscn'),
	WIN_SCENE: null, # preload("res://gui/end_screen/win/win_screen.tscn"),
}

@onready var sfx_sound_value: float:
	get: return self.get_sound_bus_volume(SFX_SOUND_BUS)
	set(value):
		self.set_sound_bus_volume(SFX_SOUND_BUS, value)
		if _current_scene_node is MainMenu:
			var main_menu_node = _current_scene_node as MainMenu
			main_menu_node.set_sfx_volume(value)

@onready var music_sound_value: float:
	get: return self.get_sound_bus_volume(MUSIC_SOUND_BUS)
	set(value):
		self.set_sound_bus_volume(MUSIC_SOUND_BUS, value)
		if _current_scene_node is MainMenu:
			var main_menu_node = _current_scene_node as MainMenu
			main_menu_node.set_music_volume(value)

var _level = 1;
var level: int:
	get: return self._level
	set(value):
		self._level = value
		if self._current_scene_node is LevelScene:
			var level_scene = _current_scene_node as LevelScene
			level_scene.unlock_level(value)
	

@onready var _current_scene_node: Node = null

func _ready():
	self.sfx_sound_value = 80.0
	self.music_sound_value = 80.0
	self._on_show_main_menu()
	TranslationServer.set_locale(LANGUAGE_ENGLISH)

func set_sound_bus_volume(bus_name: String, volume_percent: float):
	var bus_index := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume_percent / 100))

func get_sound_bus_volume(bus_name: String) ->  float:
	var bus_index := AudioServer.get_bus_index(bus_name)
	return db_to_linear(AudioServer.get_bus_volume_db(bus_index)) * 100

func _set_current_scene(scene_key: String) -> Node:
	if self._current_scene_node:
		self._current_scene_node.queue_free()
	var next_scene: PackedScene = scenes[scene_key]
	var next_scene_node: Node = next_scene.instantiate()
	self.add_child(next_scene_node)
	self._current_scene_node = next_scene_node
	
	return next_scene_node

func _on_show_main_menu() -> MainMenu:
	var main_menu_scene = self._set_current_scene(MAIN_MENU_SCENE) as MainMenu
	
	main_menu_scene.set_music_volume(music_sound_value)
	main_menu_scene.set_sfx_volume(sfx_sound_value)
	
	main_menu_scene.change_language.connect(func(language: String): TranslationServer.set_locale(language))
	main_menu_scene.sfx_value_changed.connect(func(volume_percent: float): self.sfx_sound_value=volume_percent)
	main_menu_scene.music_value_changed.connect(func(volume_percent: float): self.music_sound_value=volume_percent)
	main_menu_scene.show_levels.connect(_on_show_select_level)
	main_menu_scene.show_credits.connect(self._on_show_credits)
	
	return main_menu_scene

func _on_start_level(starting_level: int) -> Game:
	var game_scene = self._set_current_scene(GAME_SCENE) as Game
	
	game_scene.start_level(starting_level)
	
	game_scene.show_lose_screen.connect(func(): self.current_scene = LOSE_SCENE)
	game_scene.show_win_screen.connect(func(): self.current_scene = WIN_SCENE)

	if level >= FAST_MUSIC_LEVEL:
		var music_fade_tween  = get_tree().create_tween().bind_node(self)
		music_fade_tween.tween_property(main_background_theme_fast_audio_stream_player, "volume_db", 0, 5)
		music_fade_tween.tween_property(main_background_theme_audio_stream_player, "volume_db", -80.0, 5)

	return game_scene
	
func _on_show_select_level() -> LevelScene:
	var level_select_scene = self._set_current_scene(LEVEL_SCENE) as LevelScene

	level_select_scene.unlock_level(self.level)

	level_select_scene.level_selected.connect(_on_start_level)
	level_select_scene.unlock_level_till.connect(func(unlocking_level): self.level = max(self.level,unlocking_level))

	return level_select_scene
	
func _on_show_credits() -> CreditsScene:
	var credits_scene = self._set_current_scene(CREDITS_SCENE) as CreditsScene

	credits_scene.show_main_menu.connect(self._on_show_main_menu)

	return credits_scene

extends Node

const MAIN_MENU_SCENE := 'main_menu'
const GAME_SCENE := 'game'
const LEVEL_SCENE := 'level'
const LOSE_SCENE := 'lose'
const WIN_SCENE := 'win'

const LANGUAGE_ENGLISH := 'en'
const LANGUAGE_GERMAN := 'de'

const SFX_SOUND_BUS := 'SFX'
const MUSIC_SOUND_BUS := 'Music'

const main_menu_scene := preload('res://gui/main_menu.tscn')

var scenes : Dictionary = {
	MAIN_MENU_SCENE: main_menu_scene,
	GAME_SCENE: preload('res://game/game.tscn'),
	LEVEL_SCENE: preload('res://gui/level_menu/level_scene.tscn'),
	LOSE_SCENE: null, #preload('res://gui/end_screen/lose/lose_screen.tscn'),
	WIN_SCENE: null, # preload("res://gui/end_screen/win/win_screen.tscn"),
}


@onready var sfx_sound_value: float:
	get: return self.get_sound_bus_volume(SFX_SOUND_BUS)
	set(value):
		self.set_sound_bus_volume(SFX_SOUND_BUS, value)
		if current_scene_node is MainMenu:
			var main_menu_node = current_scene_node as MainMenu
			main_menu_node.set_sfx_volume(value)

@onready var music_sound_value: float:
	get: return self.get_sound_bus_volume(MUSIC_SOUND_BUS)
	set(value):
		self.set_sound_bus_volume(MUSIC_SOUND_BUS, value)
		if current_scene_node is MainMenu:
			var main_menu_node = current_scene_node as MainMenu
			main_menu_node.set_music_volume(value)

@onready var current_scene_node: Node = null
@onready var current_scene_key: String
@onready var current_scene:
	get:
		return current_scene_key
	set(value):
		var next_scene_node = self._set_current_scene(value)
		if next_scene_node is MainMenu:
			var main_menu_node = next_scene_node as MainMenu
			main_menu_node.set_music_volume(music_sound_value)
			main_menu_node.set_sfx_volume(sfx_sound_value)
			main_menu_node.change_language.connect(func(language: String): TranslationServer.set_locale(language))
			main_menu_node.sfx_value_changed.connect(func(volume_percent: float): self.sfx_sound_value=volume_percent)
			main_menu_node.music_value_changed.connect(func(volume_percent: float): self.music_sound_value=volume_percent)
		elif next_scene_node is LevelScene:
			var level_scene = next_scene_node as LevelScene
			level_scene.level_selected.connect(_on_start_level)
		#elif next_scene_node is WinScreen:
		#	var win_node = next_scene_node as WinScreen
		#	win_node.show_main_menu.connect(_on_show_main_menu)

func _ready():
	self.sfx_sound_value = 80.0
	self.music_sound_value = 80.0
	self.current_scene = MAIN_MENU_SCENE
	TranslationServer.set_locale(LANGUAGE_ENGLISH)

func set_sound_bus_volume(bus_name: String, volume_percent: float):
	var bus_index := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume_percent / 100))

func get_sound_bus_volume(bus_name: String) ->  float:
	var bus_index := AudioServer.get_bus_index(bus_name)
	return db_to_linear(AudioServer.get_bus_volume_db(bus_index)) * 100

func _set_current_scene(scene_key: String) -> Node:
	if self.current_scene_node:
		self.current_scene_node.queue_free()
	var next_scene: PackedScene = scenes[scene_key]
	var next_scene_node: Node = next_scene.instantiate()
	self.add_child(next_scene_node)
	self.current_scene_key = scene_key
	self.current_scene_node = next_scene_node
	
	return next_scene_node

func _on_start_level(level: int) -> Game:
	var game_scene = self._set_current_scene(GAME_SCENE) as Game
	game_scene.start_level(level)
	game_scene.show_lose_screen.connect(func(): self.current_scene = LOSE_SCENE)
	game_scene.show_win_screen.connect(func(): self.current_scene = WIN_SCENE)
	
	return game_scene
	
func _on_show_select_level() -> LevelScene:
	var level_select_scene = self._set_current_scene(LEVEL_SCENE) as LevelScene
	level_select_scene.level_selected.connect(_on_start_level)

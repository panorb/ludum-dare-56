extends Node

const MAIN_MENU_SCENE := 'main_menu'
const GAME_SCENE := 'game'
const LOSE_SCENE := 'lose'
const WIN_SCENE := 'win'

const LANGUAGE_ENGLISH := 'en'
const LANGUAGE_GERMAN := 'de'

const main_menu_scene := preload('res://gui/main_menu.tscn')

var scenes : Dictionary = {
	MAIN_MENU_SCENE: main_menu_scene,
	GAME_SCENE: preload("res://game/game.tscn"),
	LOSE_SCENE: null, #preload("res://gui/end_screen/lose/lose_screen.tscn"),
	WIN_SCENE: null, # preload("res://gui/end_screen/win/win_screen.tscn"),
}

@onready var current_scene_node: Node = null
@onready var current_scene_key: String
@onready var current_scene:
	get:
		return current_scene_key
	set(value):
		if self.current_scene_node:
			self.remove_child(self.current_scene_node)
		var next_scene: PackedScene = scenes[value]
		var next_scene_node: Node = next_scene.instantiate()
		self.add_child(next_scene_node)
		self.current_scene_key = value
		self.current_scene_node = next_scene_node

		if next_scene_node is MainMenu:
			var main_menu_node = next_scene_node as MainMenu
			main_menu_node.start_game.connect(func(): self.current_scene = MAIN_MENU_SCENE)
		#elif next_scene_node is LoseScreen:
		#	var lose_node = next_scene_node as LoseScreen
		#	lose_node.show_main_menu.connect(_on_show_main_menu)
		#elif next_scene_node is WinScreen:
		#	var win_node = next_scene_node as WinScreen
		#	win_node.show_main_menu.connect(_on_show_main_menu)
		elif next_scene_node is Game:
			var game_node = next_scene_node as Game
			game_node.show_lose_screen.connect(func(): self.current_scene = LOSE_SCENE)
			game_node.show_win_screen.connect(func(): self.current_scene = WIN_SCENE)

func _ready():
	self.current_scene = MAIN_MENU_SCENE
	TranslationServer.set_locale(LANGUAGE_ENGLISH)

#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _easy_path: String = String("") \
	setget set_easy_path, get_easy_path

var _medium_path: String = String("") \
	setget set_medium_path, get_medium_path

var _hard_path: String = String("") \
	setget set_hard_path, get_hard_path

var _start_game_path: String = String("") \
	setget set_start_game_path, get_start_game_path




#  [ONREADY_VARIABLES]
onready var game_title: Label = $"MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/Tittle"
onready var level_title: Label = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Options/Panel/Tittle
onready var game_name: Label = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/GameName
onready var logo_background: PanelContainer = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/PanelContainer2/Circle
onready var logo_api: TextureRect = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/PanelContainer/Image
onready var panel_logo_api: PanelContainer = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/PanelContainer
onready var logo: TextureRect = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/PanelContainer2/Image
onready var panel_logo_placeholder: PanelContainer = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/PanelContainer2
onready var levels_panel: Panel = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Options/Panel
onready var start_game_button: Button = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Options/StartGame
onready var easy_button: Button = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Options/Panel/MarginContainer/HBoxContainer/Easy
onready var medium_button: Button = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Options/Panel/MarginContainer/HBoxContainer/Medium
onready var hard_button: Button = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Options/Panel/MarginContainer/HBoxContainer/Hard

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()

	game_title.text = API.common.get_short_title().to_upper()

	match(API.common.get_resource_id()):

		API.ResourceID.METCHING_GAME:
			_metching_game_home()

		API.ResourceID.MOMORY_GAME:
			_memory_game_home()

		API.ResourceID.QUIZ:
			_quiz_home()

		API.ResourceID.PUZZLE:
			_puzzle_home()

		API.ResourceID.CRYPTOGRAM:
			_cryptogram_home()

		API.ResourceID.WORDHUNT:
			_wordhunt_home()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_easy_path(new_value: String) -> void:
	_easy_path = new_value


func get_easy_path() -> String:
	return _easy_path


func set_medium_path(new_value: String) -> void:
	_medium_path = new_value


func get_medium_path() -> String:
	return _medium_path


func set_hard_path(new_value: String) -> void:
	_hard_path = new_value


func get_hard_path() -> String:
	return _hard_path


func set_start_game_path(new_value: String) -> void:
	_start_game_path = new_value


func get_start_game_path() -> String:
	return _start_game_path


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	if API.common.get_game_logo() == null:
		panel_logo_api.visible = false
		panel_logo_placeholder.visible = true
		var logo_background_style: StyleBoxFlat = logo_background.get("custom_styles/panel")
		logo_background_style.set("bg_color", API.theme.get_color(API.theme.SB))
	else:
		panel_logo_api.visible = true
		panel_logo_placeholder.visible = false
		logo_api.texture = API.common.get_game_logo()

	var game_name_font: Font = game_name.get("custom_fonts/font")
	game_name_font.set("outline_color", API.theme.get_color(API.theme.PD1))

	game_title.set("custom_colors/font_color", API.theme.get_color(API.theme.PD1))
	var game_title_state_normal: StyleBoxFlat = game_title.get("custom_styles/normal")
	game_title_state_normal.set("border_color", API.theme.get_color(API.theme.PD1))

	level_title.set("custom_colors/font_color", API.theme.get_color(API.theme.PD1))
	var level_title_state_normal: StyleBoxFlat = game_title.get("custom_styles/normal")
	level_title_state_normal.set("border_color", API.theme.get_color(API.theme.PD1))


func _memory_game_home() -> void:

	logo.texture = load("res://assets/images/logo_memory_game.png")

	game_name.text = "JOGO DA MEMÓRIA"

	start_game_button.visible = false
	levels_panel.visible = true

	# Check data for levels
	if API.game.has_locked_levels()["easy"]:
		easy_button.disabled = true
	if API.game.has_locked_levels()["medium"]:
		medium_button.disabled = true
	if API.game.has_locked_levels()["hard"]:
		hard_button.disabled = true

	var path: String = "res://games/memory_game/memory_game.tscn"
	set_easy_path(path)
	set_medium_path(path)
	set_hard_path(path)


func _quiz_home() -> void:
	logo.texture = load("res://assets/images/logo_quiz.png")

	game_name.text = "QUIZ"

	start_game_button.visible = true
	levels_panel.visible = false

	set_start_game_path("res://games/quiz/quiz.tscn")


func _metching_game_home() -> void:

	logo.texture = load("res://assets/images/logo_matching_game.png")

	game_name.text = "JOGO DA COMBINAÇÃO"

	start_game_button.visible = false
	levels_panel.visible = true

	# Check data for levels
	if API.game.has_locked_levels()["easy"]:
		easy_button.disabled = true
	if API.game.has_locked_levels()["medium"]:
		medium_button.disabled = true
	if API.game.has_locked_levels()["hard"]:
		hard_button.disabled = true

	var path: String = "res://games/matching_game/matching_game.tscn"
	set_easy_path(path)
	set_medium_path(path)
	set_hard_path(path)


func _puzzle_home() -> void:
	logo.texture = load("res://assets/images/logo_puzzle_game.png")

	game_name.text = "QUEBRA-CABEÇAS"

	start_game_button.visible = true
	levels_panel.visible = false

	set_start_game_path("res://games/puzzle/puzzle.tscn")


func _cryptogram_home() -> void:
	logo.texture = load("res://assets/images/logo_cryptogram.png")

	game_name.text = "CRIPTOGRAMA"

	start_game_button.visible = true
	levels_panel.visible = false

	set_start_game_path("res://games/cryptogram/cryptogram.tscn")


func _wordhunt_home() -> void:
	logo.texture = load("res://assets/images/logo_wordhunt.png")

	game_name.text = "CAÇA-PALAVRAS"

	start_game_button.visible = true
	levels_panel.visible = false

	set_start_game_path("res://games/wordhunt/wordhunt.tscn")


#  [SIGNAL_METHODS]
func _on_Easy_pressed() -> void:
	ChangeLevel.request_mode = ChangeLevel.GameMode.EASY
	get_tree().change_scene(get_easy_path())


func _on_Medium_pressed() -> void:
	ChangeLevel.request_mode = ChangeLevel.GameMode.MEDIUM
	get_tree().change_scene(get_medium_path())


func _on_Hard_pressed() -> void:
	ChangeLevel.request_mode = ChangeLevel.GameMode.HARD
	get_tree().change_scene(get_hard_path())


func _on_Credits_pressed() -> void:
	get_tree().change_scene("res://credits/credits.tscn")


func _on_StartGame_pressed() -> void:
	get_tree().change_scene(get_start_game_path())

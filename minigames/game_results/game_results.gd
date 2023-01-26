#tool
#class_name Name #, res://class_name_icon.svg
extends Panel


#  [DOCSTRING]


#  [SIGNALS]
signal restart_level
signal continue_level
signal updated_data


#  [ENUMS]
enum GameMode {EASY, MEDIUM, HARD}


#  [CONSTANTS]
const HOME_PATH: String = String("res://home/home.tscn")


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _total_stars: int = int(0) \
		setget set_total_stars, get_total_stars

var _current_mode: int = GameMode.EASY \
		setget set_current_mode, get_current_mode

var _home_path: String = String(HOME_PATH) \
		setget set_home_path, get_home_path


#  [ONREADY_VARIABLES]
onready var title: Label = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/Title
onready var game_message: RichTextLabel = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/GameMessage
onready var stars: HBoxContainer = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/Stars
onready var first_star: Label = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/Stars/First
onready var second_star: Label = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/Stars/Second
onready var third_star: Label = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/Stars/Third
onready var statistic_message: RichTextLabel = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/StatisticMessage
onready var mascot_image: TextureRect = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MascotContainer/MascotImage
onready var mascot_background: TextureRect = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MascotContainer/MascotBackground
onready var hide_panel: Button = $MainPanel/HidePanel
onready var show_panel: Button = $ShowPanel
onready var main_panel: Panel = $MainPanel
onready var continue_button: Button = $MainPanel/MarginContainer/GlobalContainer/ButtonsContainer/Continue
#onready var restart_button: Button = $MainPanel/MarginContainer/GlobalContainer/ButtonsContainer/Restart
#onready var share_button: Button = $MainPanel/MarginContainer/GlobalContainer/ButtonsContainer/Share


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	self.visible = false
	connect("updated_data", self, "_on_Self_updated_data")


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_total_stars(new_value: int) -> void:
	_total_stars = new_value


func get_total_stars() -> int:
	return _total_stars


func set_current_mode(new_value: int) -> void:
	_current_mode = new_value
	
	if API.game.has_levels():
		match(_current_mode):
			GameMode.EASY:
				if API.game.has_locked_levels().has("medium"):
					if API.game.has_locked_levels()["medium"]:
						continue_button.text = ""
						continue_button.hint_tooltip = "Menu Principal"
						set_home_path(HOME_PATH)
						hide_panel.visible = false
					else:
						continue_button.text = ""
						continue_button.hint_tooltip = "Continue"
						set_home_path("")
						hide_panel.visible = true
	
			GameMode.MEDIUM:
				if API.game.has_locked_levels().has("hard"):
					if API.game.has_locked_levels()["hard"]:
						continue_button.text = ""
						continue_button.hint_tooltip = "Menu Principal"
						set_home_path(HOME_PATH)
						hide_panel.visible = false
					else:
						continue_button.text = ""
						continue_button.hint_tooltip = "Continue"
						set_home_path("")
						hide_panel.visible = true
	
			GameMode.HARD:
				continue_button.text = ""
				continue_button.hint_tooltip = "Menu Principal"
				set_home_path(HOME_PATH)
				hide_panel.visible = false


func get_current_mode() -> int:
	return _current_mode


func set_home_path(new_value: String) -> void:
	_home_path = new_value


func get_home_path() -> String:
	return _home_path


func update_data(message_game: String, message_statistic: String, total_stars: int, current_mode: int = 0) -> void:
	game_message.bbcode_enabled = true
	game_message.bbcode_text = message_game
	statistic_message.bbcode_enabled = true
	statistic_message.bbcode_text = message_statistic
	set_total_stars(total_stars)
	set_current_mode(current_mode)
	emit_signal("updated_data")


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	title.set("custom_colors/font_color", API.theme.get_color(API.theme.PB))
	
	_update_stars_color()
	
	mascot_image.texture = API.common.get_mascot()
	mascot_background.set("modulate", API.theme.get_color(API.theme.PL3))
 

func _update_stars_color() -> void:
	match(get_total_stars()):
		0:
			first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
			second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
			third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
		1:
			first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
			third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
		2:
			first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
		3:
			first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))


#  [SIGNAL_METHODS]
func _on_Self_updated_data() -> void:
	_load_theme()
	self.visible = true


func _on_HidePanel_pressed() -> void:
	main_panel.visible = false
	show_panel.visible = true


func _on_ShowPanel_pressed() -> void:
	show_panel.visible = false
	main_panel.visible = true


func _on_Share_pressed() -> void:
	pass


func _on_Restart_pressed() -> void:
	emit_signal("restart_level")
	self.queue_free()


func _on_Continue_pressed() -> void:
	if get_home_path() == "":
		emit_signal("continue_level")
		self.queue_free()
	else:
		get_tree().change_scene(get_home_path())

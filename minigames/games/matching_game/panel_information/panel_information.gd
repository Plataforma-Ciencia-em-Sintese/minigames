#tool
#class_name Name #, res://class_name_icon.svg
extends Panel


#  [DOCSTRING]


#  [SIGNALS]
signal restart_level
signal continue_level


#  [ENUMS]
enum GameMode {EASY, MEDIUM, HARD}


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _total_score: int = int(0) \
		setget set_total_score, get_total_score

var _total_time: int = int(0) \
		setget set_total_time, get_total_time

var _total_attempts: int = int(0) \
		setget set_total_attempts, get_total_attempts

var _current_mode: int = GameMode.EASY \
		setget set_current_mode, get_current_mode


#  [ONREADY_VARIABLES]
onready var title_message: Label = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/CongratulationsContainer/Title
onready var result_message: RichTextLabel = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/CongratulationsContainer/TotalRecord
onready var record_message: Label = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/RecordContainer/NewRecord
onready var stars: HBoxContainer = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/RecordContainer/Stars
onready var first_star: Label = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/RecordContainer/Stars/First
onready var second_star: Label = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/RecordContainer/Stars/Second
onready var third_star: Label = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/RecordContainer/Stars/Third
onready var mascot_image: TextureRect = $MainPanel/MarginContainer/GlobalContainer/MainContainer/AspectRatioContainer/MascotImage
onready var mascot_background: TextureRect = $MainPanel/MarginContainer/GlobalContainer/MainContainer/AspectRatioContainer/MascotBackground
onready var hide_panel: Button = $MainPanel/HidePanel
onready var show_panel: Button = $ShowPanel
onready var main_panel: Panel = $MainPanel
onready var total_time: Label = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/StatisticsContainer/TimeContainer/TotalTime
onready var total_attempts: Label = $MainPanel/MarginContainer/GlobalContainer/MainContainer/MessageContainer/StatisticsContainer/AttemptsContainer/TotalAttempts
onready var continue_button: Button = $MainPanel/MarginContainer/GlobalContainer/ButtonsContainer/Continue

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	self.visible = false
	mascot_image.texture = API.common.get_mascot()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func init_panel(total_score: int, total_time: int, total_attempts: int, current_mode: int) -> void:
	set_total_score(total_score)
	set_total_time(total_time)
	set_total_attempts(total_attempts)
	set_current_mode(current_mode)
	
	_load_theme()
	
	self.visible = true


func set_total_score(new_value: int) -> void:
	_total_score = new_value


func get_total_score() -> int:
	return _total_score


func set_total_time(new_value: int) -> void:
	_total_time = new_value
	var seconds: int = _total_time
	
# warning-ignore:integer_division
	total_time.text = "%02d:%02d" % [(seconds/60) % 60, seconds % 60]


func get_total_time() -> int:
	return _total_time


func set_total_attempts(new_value: int) -> void:
	_total_attempts = new_value
	
	total_attempts.text = "%02d" % [_total_attempts]


func get_total_attempts() -> int:
	return _total_attempts


func set_current_mode(new_value: int) -> void:
	_current_mode = new_value
	_check_data_level()


func get_current_mode() -> int:
	return _current_mode


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	title_message.set("custom_colors/font_color", API.theme.get_color(API.theme.PB))
	record_message.set("custom_colors/font_color", API.theme.get_color(API.theme.PD1))
	
	_star_rule(get_total_score())
	
	total_time.set("custom_colors/font_color", API.theme.get_color(API.theme.SB))
	total_attempts.set("custom_colors/font_color", API.theme.get_color(API.theme.SB))
	
	result_message.bbcode_text = ("Você completou o nível!\n" +
	"Conseguiu [color=#" + str(API.theme.get_color(API.theme.SB).to_html(false)) + 
	"][b]" + str(get_total_score()) + "[/b][/color] estrelas.")
	
	mascot_background.set("modulate", API.theme.get_color(API.theme.PL3))
 

func _star_rule(stars: int) -> void:
	
	match(stars):
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


func _check_data_level() -> String:
	var home_path: String = "res://home/home.tscn"
	var targets: int = API.game.get_targets().size()
	var bullets: int = API.game.get_bullets().size()
	
	match(get_current_mode()):
		GameMode.EASY:
			if (targets + bullets) < 18 or targets != bullets:
				continue_button.text = ""
				continue_button.hint_tooltip = "Menu Principal"
			else:
				continue_button.text = ""
				continue_button.hint_tooltip = "Continue"
				home_path = ""
			
			
		GameMode.MEDIUM:
			if (targets + bullets) < 32 or targets != bullets:
				continue_button.text = ""
				continue_button.hint_tooltip = "Menu Principal"
			else:
				continue_button.text = ""
				continue_button.hint_tooltip = "Continue"
				home_path = ""
			
		GameMode.HARD:
			continue_button.text = ""
			continue_button.hint_tooltip = "Menu Principal"
	
	return home_path


#  [SIGNAL_METHODS]
func _on_HidePanel_pressed() -> void:
	main_panel.visible = false
	show_panel.visible = true


func _on_ShowPanel_pressed() -> void:
	show_panel.visible = false
	main_panel.visible = true


func _on_Continue_pressed() -> void:
	if _check_data_level() == "":
		emit_signal("continue_level")
		self.queue_free()
	else:
		get_tree().change_scene(_check_data_level())


func _on_Restart_pressed() -> void:
	emit_signal("restart_level")
	self.queue_free()


func _on_Share_pressed() -> void:
	pass

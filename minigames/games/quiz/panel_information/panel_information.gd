#tool
#class_name Name #, res://class_name_icon.svg
extends Panel


#  [DOCSTRING]


#  [SIGNALS]
signal restart_level
signal continue_level


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _game_score: int = int(0) \
		setget set_game_score, get_game_score

var _total_score: int = int(0) \
		setget set_total_score, get_total_score


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
func init_panel(game_score: int, total_score: int) -> void:
	set_game_score(game_score)
	set_total_score(total_score)
	
	_load_theme()
	
	self.visible = true


#  [PRIVATE_METHODS]
func set_game_score(new_value: int) -> void:
	_game_score = new_value


func get_game_score() -> int:
	return _game_score


func set_total_score(new_value: int) -> void:
	_total_score = new_value


func get_total_score() -> int:
	return _total_score


func _load_theme() -> void:
	title_message.set("custom_colors/font_color", API.theme.get_color(API.theme.PB))
	record_message.set("custom_colors/font_color", API.theme.get_color(API.theme.PD1))
	
	_star_rule()
	
	total_time.set("custom_colors/font_color", API.theme.get_color(API.theme.SB))
	total_attempts.set("custom_colors/font_color", API.theme.get_color(API.theme.SB))
	
	result_message.bbcode_text = ("Você acertou [color=#" +
	str(API.theme.get_color(API.theme.SB).to_html(false)) + "][b]" +
	str(get_game_score()) + "[/b][/color] de [color=#" +
	str(API.theme.get_color(API.theme.SB).to_html(false)) + "][b]" +
	str(get_total_score()) + "[/b][/color]" + "\n" + " perguntas.")
	
	mascot_background.set("modulate", API.theme.get_color(API.theme.PL3))
 

func _star_rule() -> void:
	var value: float = (float(get_game_score() * 100)) / float(get_total_score())
	
	print(value)
	
	# 0 estrelas: 0% a 20%
	if value >= 0.0 and value < 20.0:
		first_star.set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
		second_star.set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
		third_star.set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
	
	# 1 estrela: 20% a 50%
	if value >= 20.0 and value < 50.0:
		first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.SB))
		second_star.set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
		third_star.set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
	
	# 2 estrelas: 50% a 80%
	if value >= 50.0 and value < 80.0:
		first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.SB))
		second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.SB))
		third_star.set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 0.0))
	
	# 3 estrelas: 80% a 100%
	if value >= 80.0 and value < 100.0:
		first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.SB))
		second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.SB))
		third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.SB))


#  [SIGNAL_METHODS]


func _on_HidePanel_pressed() -> void:
	main_panel.visible = false
	show_panel.visible = true


func _on_ShowPanel_pressed() -> void:
	show_panel.visible = false
	main_panel.visible = true


func _on_Continue_pressed() -> void:
	#emit_signal("continue_level")
	get_tree().change_scene("res://home/home.tscn")


func _on_Restart_pressed() -> void:
	#emit_signal("restart_level")
	get_tree().change_scene("res://games/quiz/quiz.tscn")


func _on_Share_pressed() -> void:
	pass

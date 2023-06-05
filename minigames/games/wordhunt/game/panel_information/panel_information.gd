#tool
#class_name Name #, res://class_name_icon.svg
extends Panel


#  [DOCSTRING]


#  [SIGNALS]
signal button_next_level_pressed
signal button_restart_level_pressed
signal button_hide_pressed
signal button_show_pressed


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]
onready var tittle_message: Label = $GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/CongratulationsContainer/Message
onready var total_stars: RichTextLabel = $GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/CongratulationsContainer/TotalStars
onready var record_message: Label = $GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/RecordContainer/Message
onready var stars: HBoxContainer = $GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/RecordContainer/Stars
onready var time_counter: Label = $GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/StatisticsContainer/TimeContainer/TotalTime
onready var attempts_counter: Label = $GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/StatisticsContainer/AttemptsContainer/TotalAttempts
onready var hide: Button = $GlobalContainer/Hide
onready var show: Button = $"../ShowPanelInformation"
onready var character_image: TextureRect = $GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/Character


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()
	character_image.texture = API.common.get_mascot()
	


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	tittle_message.set("custom_colors/font_color", API.theme.get_color(API.theme.PB))
	record_message.set("custom_colors/font_color", API.theme.get_color(API.theme.PD1))
	
	for star in stars.get_children():
		star.set("custom_colors/font_color", API.theme.get_color(API.theme.SB))
	
	time_counter.set("custom_colors/font_color", API.theme.get_color(API.theme.PB))
	attempts_counter.set("custom_colors/font_color", API.theme.get_color(API.theme.PB))
	
	hide.set("custom_colors/font_color", API.theme.get_color(API.theme.WHITE))
	hide.set("custom_colors/font_color_hover", API.theme.get_color(API.theme.WHITE))
	hide.set("custom_colors/font_color_pressed", API.theme.get_color(API.theme.SB))
	
	var hide_state_hover: StyleBoxFlat = hide.get("custom_styles/hover")
	hide_state_hover.set("bg_color", API.theme.get_color(API.theme.SL1))
	hide_state_hover.set("border_color", API.theme.get_color(API.theme.SD2))
	
	var hide_state_pressed: StyleBoxFlat = hide.get("custom_styles/pressed")
	hide_state_pressed.set("bg_color", API.theme.get_color(API.theme.WHITE))
	hide_state_pressed.set("border_color", API.theme.get_color(API.theme.SD2))
	
	var hide_state_focus: StyleBoxFlat = hide.get("custom_styles/focus")
	hide_state_focus.set("bg_color", API.theme.get_color(API.theme.SL1))
	hide_state_focus.set("border_color", API.theme.get_color(API.theme.SD2))
	
	var hide_state_disabled: StyleBoxFlat = hide.get("custom_styles/disabled")
	hide_state_disabled.set("bg_color", API.theme.get_color(API.theme.SB))
	hide_state_disabled.set("border_color", API.theme.get_color(API.theme.SD2))
	
	var hide_state_normal: StyleBoxFlat = hide.get("custom_styles/normal")
	hide_state_normal.set("bg_color", API.theme.get_color(API.theme.SB))
	hide_state_normal.set("border_color", API.theme.get_color(API.theme.SD2))
	
	show.set("custom_colors/font_color", API.theme.get_color(API.theme.WHITE))
	show.set("custom_colors/font_color_hover", API.theme.get_color(API.theme.WHITE))
	show.set("custom_colors/font_color_pressed", API.theme.get_color(API.theme.SB))
	
	var show_state_hover: StyleBoxFlat = show.get("custom_styles/hover")
	show_state_hover.set("bg_color", API.theme.get_color(API.theme.SL1))
	show_state_hover.set("border_color", API.theme.get_color(API.theme.SD2))
	
	var show_state_pressed: StyleBoxFlat = show.get("custom_styles/pressed")
	show_state_pressed.set("bg_color", API.theme.get_color(API.theme.WHITE))
	show_state_pressed.set("border_color", API.theme.get_color(API.theme.SD2))
	
	var show_state_focus: StyleBoxFlat = show.get("custom_styles/focus")
	show_state_focus.set("bg_color", API.theme.get_color(API.theme.SL1))
	show_state_focus.set("border_color", API.theme.get_color(API.theme.SD2))
	
	var show_state_disabled: StyleBoxFlat = show.get("custom_styles/disabled")
	show_state_disabled.set("bg_color", API.theme.get_color(API.theme.SB))
	show_state_disabled.set("border_color", API.theme.get_color(API.theme.SD2))
	
	var show_state_normal: StyleBoxFlat = show.get("custom_styles/normal")
	show_state_normal.set("bg_color", API.theme.get_color(API.theme.SB))
	show_state_normal.set("border_color", API.theme.get_color(API.theme.SD2))


#  [SIGNAL_METHODS]


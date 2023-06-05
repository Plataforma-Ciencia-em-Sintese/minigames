#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]
const DEFAULT_ERRO_MESSAGE: String = "Error!"
const DEFAULT_LOADING_MESSAGE: String = "Loading ..."


#  [EXPORTED_VARIABLES]
export var loading_color: Color = Color()
export var error_color: Color = Color()
export(String, MULTILINE) var loading_message: String = DEFAULT_LOADING_MESSAGE
export(String, MULTILINE) var error_message: String = DEFAULT_ERRO_MESSAGE


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _message: String = DEFAULT_LOADING_MESSAGE \
		setget set_message, get_message


#  [ONREADY_VARIABLES]
onready var rich_text_label: RichTextLabel = $"MarginContainer/RichTextLabel"


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	if loading_message != DEFAULT_LOADING_MESSAGE:
		set_message(loading_message)
	else:
		set_message(DEFAULT_LOADING_MESSAGE)
	
	rich_text_label.set("custom_colors/default_color", loading_color)
	rich_text_label.bbcode_text = "[center][wave amp=12 freq=6]" + get_message() + "[/wave][/center]"


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_message(new_value: String) -> void:
	_message = new_value


func get_message() -> String:
	return _message


func error() -> void:
	if error_message != DEFAULT_ERRO_MESSAGE:
		set_message(error_message)
	else:
		set_message(DEFAULT_ERRO_MESSAGE)
	
	rich_text_label.set("custom_colors/default_color", error_color)
	rich_text_label.bbcode_text = "[center][wave amp=0 freq=0]" + get_message() + "[/wave][/center]"
	


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

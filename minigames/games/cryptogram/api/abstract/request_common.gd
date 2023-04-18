#tool
class_name RequestCommon #, res://class_name_icon.svg
extends Request


#  [DOCSTRING]


#  [SIGNALS]
# warning-ignore:unused_signal
signal all_request_common_completed


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _short_title: String = "" \
		setget set_short_title, get_short_title

var _article_summary: String = "" \
		setget set_article_summary, get_article_summary

var _game_logo: ImageTexture = null \
		setget set_game_logo, get_game_logo

var _article_link: String = "" \
		setget set_article_link, get_article_link

var _content_credits: String = "" \
		setget set_content_credits, get_content_credits
		
var _mascot: ImageTexture = null \
		setget set_mascot, get_mascot

var _pet: ImageTexture = null \
		setget set_pet, get_pet



#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
#func _ready() -> void:
#	pass


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_short_title(new_value: String) -> void:
	_short_title = new_value


func get_short_title() -> String:
	return _short_title


func set_article_summary(new_value: String) -> void:
	_article_summary = new_value
	


func get_article_summary() -> String:
	return _article_summary


func set_game_logo(new_value: ImageTexture) -> void:
	_game_logo = new_value


func get_game_logo() -> ImageTexture:
	return _game_logo


func set_article_link(new_value: String) -> void:
	_article_link = new_value


func get_article_link() -> String:
	return _article_link


func set_content_credits(new_value: String) -> void:
	_content_credits = new_value


func get_content_credits() -> String:
	return _content_credits


func set_mascot(new_value: ImageTexture) -> void:
	_mascot = new_value


func get_mascot() -> ImageTexture:
	return _mascot


func set_pet(new_value: ImageTexture) -> void:
	_pet = new_value


func get_pet() -> ImageTexture:
	return _pet


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

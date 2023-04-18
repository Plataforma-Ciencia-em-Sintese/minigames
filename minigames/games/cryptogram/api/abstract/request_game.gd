#tool
class_name RequestGame #, res://class_name_icon.svg
extends Request


#  [DOCSTRING]


#  [SIGNALS]
signal all_request_game_completed


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
# _cards, expected value: [{"image": value, "subtitle": value}, ...]
var _words: Dictionary = Dictionary() \
		setget set_words, get_words

#var _clues: Array = Array()\
#		setget set_clues, get_clues

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
func set_words(new_value: Dictionary) -> void:
	pass


func get_words() -> Dictionary:
	return _words


#func set_clues(new_value: Array) -> void:
#	pass
#
#
#func get_clues() -> Array:
#	return _clues


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

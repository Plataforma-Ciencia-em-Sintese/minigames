#tool
class_name RequestMemoryGame #, res://class_name_icon.svg
extends Request


#  [DOCSTRING]


#  [SIGNALS]
# warning-ignore:unused_signal
signal all_request_game_completed


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
# _cards, expected value: [{"image": value, "subtitle": value}, ...]
var _cards: Array = Array() \
		setget set_cards, get_cards


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
func set_cards(new_value: Array) -> void:
	_cards = new_value


func get_cards() -> Array:
	return _cards


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

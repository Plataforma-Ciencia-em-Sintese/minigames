#tool
class_name RequestMatchingGame #, res://class_name_icon.svg
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
var _bullets: Array = Array() \
		setget set_bullets, get_bullets
		
var _targets: Array = Array() \
		setget set_targets, get_targets


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
func set_bullets(new_value: Array) -> void:
	_bullets = new_value


func get_bullets() -> Array:
	return _bullets
	
func set_targets(new_value: Array) -> void:
	_targets = new_value


func get_targets() -> Array:
	return _targets


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

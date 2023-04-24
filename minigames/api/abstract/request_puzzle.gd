#tool
class_name RequestPuzzle #, res://class_name_icon.svg
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
var _texture_images: Array = Array() \
		setget set_texture_images, get_texture_images


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
func set_texture_images(new_value: Array) -> void:
	_texture_images = new_value


func get_texture_images() -> Array:
	return _texture_images


func has_levels() -> bool:
	""" 
	Must return TRUE if HOME scene 
	is to display level selection 
	"""
	return false


func has_locked_levels() -> Dictionary:
	"""
	Must return TRUE for a level to be 
	locked. Levels are blocked when the 
	SERVER doesn't provide enough data for a level.
	
	{"easy": true, "medium": true, "hard": true}
	"""
	var levels: Dictionary = Dictionary({})
	
	# Check all levels
	
	return levels


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

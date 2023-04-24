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


func has_levels() -> bool:
	""" 
	Must return TRUE if HOME scene 
	is to display level selection 
	"""
	return true


func has_locked_levels() -> Dictionary:
	"""
	Must return TRUE for a level to be 
	locked. Levels are blocked when the 
	SERVER doesn't provide enough data for a level.
	
	{"easy": true, "medium": true, "hard": true}
	"""
	var levels: Dictionary = Dictionary({})
	
	# Check all levels
	var targets: int = get_targets().size()
	var bullets: int = get_bullets().size()
	# check easy level
	if (targets + bullets) < 12 or targets != bullets:
		levels["easy"] = true
	else:
		levels["easy"] = false
	# check medium level
	if (targets + bullets) < 18 or targets != bullets:
		levels["medium"] = true
	else:
		levels["medium"] = false
	# check hard level
	if (targets + bullets) < 32 or targets != bullets:
		levels["hard"] = true
	else:
		levels["hard"] = false
	
	return levels


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

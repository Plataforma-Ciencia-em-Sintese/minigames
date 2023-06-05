#tool
class_name URL #, res://class_name_icon.svg
#extends Node


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


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
static func get_parameters(fake_url: String = "") -> Dictionary:
	# Get URL parameters
	var raw_string: String = ""
	if str(OS.get_name()) == "HTML5":
		# The Javascript Class only works for HTML5.
		if str(JavaScript.eval("window.location.search;")) != "":
			raw_string = str(JavaScript.eval("window.location.search;"))
			raw_string = raw_string.split("?")[1]
		else:
			push_error("Expected URL parameters but none found.")
			return Dictionary()
	
	# For testing in environments other than HTML5.
	else:
		if fake_url == "":
			fake_url = "https://.../?fake_url=yes&test=1&os=" + str(OS.get_name())
		
		raw_string = fake_url.split("?")[1]
	
	var strings: PoolStringArray = raw_string.split("&")
	
	var parameters: Dictionary = Dictionary()
	for item in strings:
		parameters[item.split("=")[0]] = item.split("=")[1]

	return parameters


static func is_parameters() -> bool:
	if str(JavaScript.eval("window.location.search;")) == "":
		return false
	return true


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

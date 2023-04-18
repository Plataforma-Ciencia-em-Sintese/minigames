#tool
class_name Request #, res://class_name_icon.svg
extends Node


#  [DOCSTRING]


#  [SIGNALS]
signal request_error(request_failed)


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
static func request(http_request_instance: HTTPRequest, url: String) -> void:
	var ssl_validate_domain: bool = false
	http_request_instance.use_threads = true
	
	if OS.get_name() == "HTML5":
		ssl_validate_domain = true
		http_request_instance.use_threads = false
		http_request_instance.set_block_signals(false)
	
	var error: int = http_request_instance.request(url, PoolStringArray(), ssl_validate_domain)
	if error != OK:
		push_error("Request: An error occurred in the HTTP request.")


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

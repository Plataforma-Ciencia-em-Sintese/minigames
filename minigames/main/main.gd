#tool
#class_name Name #, res://class_name_icon.svg
extends Node


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]
onready var loading_status: Control = $"Loading"


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	if URL.is_parameters():
		API.connect("all_request_completed", self, "_on_init_game")
		API.connect("all_request_failed", self, "_on_return_error")
	else:
		loading_status.show_error()
		print("\nThe data request failed!\n")
		print("\nThe game cannot be loaded!\n")



#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]


#  [SIGNAL_METHODS]
func _on_init_game() -> void:
	print("\nAll requests have been completed!\n")
	print("\nFull game loading!\n")

	get_tree().change_scene("res://opening/opening.tscn")


func _on_return_error() -> void:
	loading_status.show_error()
	print("\nThe data request failed!\n")
	print("\nThe game cannot be loaded!\n")

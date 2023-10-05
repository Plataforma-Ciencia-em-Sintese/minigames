#tool
#class_name Name #, res://class_name_icon.svg
extends CanvasLayer


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]
var button: Button = null


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
#func _ready() -> void:
#	pass


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass

func _enter_tree() -> void:
	button = $Button
	get_viewport().connect("size_changed", self, "_on_size_changed")

#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _toggle_fullscreen_button_icon() -> void:
	var fullscreen_on: String = ""
	var fullscreen_off: String = ""
	match(OS.window_fullscreen):
		true:
			button.text = fullscreen_off
		false:
			button.text = fullscreen_on
	
 

#  [SIGNAL_METHODS] 
func _on_Button_pressed() -> void:
	OS.window_fullscreen = !OS.window_fullscreen
	_toggle_fullscreen_button_icon()

func _on_size_changed() -> void:
	_toggle_fullscreen_button_icon()

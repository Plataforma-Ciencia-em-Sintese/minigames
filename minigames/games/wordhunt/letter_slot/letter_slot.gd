#tool
#class_name Name #, res://class_name_icon.svg
extends Label


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _mouse_hover: bool = false\
		setget set_mouse_hover, get_mouse_hover

var _emitted: bool = false


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
#func _ready() -> void:
#	pass


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
func _process(_delta: float) -> void:
	if Rect2(Vector2.ZERO, rect_size).has_point(get_local_mouse_position()):
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			if not _emitted:
				_emitted = true
				print(text)
	else:
		_emitted = false
		set_mouse_hover(false)


#  [PUBLIC_METHODS]
func set_mouse_hover(new_value: bool) -> void:
	if new_value == true and _mouse_hover == false:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			print(text)

	_mouse_hover = new_value



func get_mouse_hover() -> bool:
	return _mouse_hover


#  [PRIVATE_METHODS]


#  [SIGNAL_METHODS]

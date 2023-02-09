#tool
#class_name Name #, res://class_name_icon.svg
extends TextureRect


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _busy: bool = false \
		setget set_busy, get_busy


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
func set_busy(new_value: bool) -> void:
	_busy = new_value


func get_busy() -> bool:
	return _busy


func can_drop_data(position: Vector2, data) -> bool:
	return !get_busy()


func drop_data(position: Vector2, data: Dictionary) -> void:
	print(data)


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

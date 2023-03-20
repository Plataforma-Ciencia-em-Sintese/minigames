#tool
#class_name Name #, res://class_name_icon.svg
extends Panel


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _busy: bool = false \
		setget set_busy, get_busy

var _id: int = int(0) \
		setget set_id, get_id


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


func set_id(new_value: int) -> void:
	_id = new_value


func get_id() -> int:
	return _id


func can_drop_data(position: Vector2, data) -> bool:
	return !get_busy()


func drop_data(position: Vector2, data: Dictionary) -> void:
	data["piece"].rect_global_position = self.rect_global_position
	print("\n-------------")
	print("\npiece: ", data["piece"].get_id())
	print("\nslot: ", self.get_id())


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

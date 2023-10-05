#tool
#class_name Name #, res://class_name_icon.svg
extends Panel


#  [DOCSTRING]


#  [SIGNALS]
signal occupied


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _busy: bool = false \
		setget set_busy, get_busy

var _id: int = int(0) \
		setget set_id, get_id

var _dropped_piece: Control = null \
		setget set_dropped_piece, get_dropped_piece


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


func set_dropped_piece(new_value: Control) -> void:
	_dropped_piece = new_value


func get_dropped_piece() -> Control:
	return _dropped_piece


func can_drop_data(_position: Vector2, _data) -> bool:
	return !get_busy()


func drop_data(_position: Vector2, data: Dictionary) -> void:
	data["piece"].rect_global_position = self.rect_global_position
	
	data["piece"].connect("dropped", self, "_on_Piece_dropped")
	
	set_dropped_piece(data["piece"])
	
	set_busy(true)
	
	emit_signal("occupied", self, data["piece"])
	
#	print("\nself: ", self)
#	print("data:busy: ", get_busy())
#	print("data:piece: ", get_dropped_piece())


func check_dropped_piece() -> void:
	if get_dropped_piece() != null:
		if get_dropped_piece().rect_global_position != self.rect_global_position:
			if get_dropped_piece().is_connected("dropped", self, "_on_Piece_dropped"):
				get_dropped_piece().disconnect("dropped", self, "_on_Piece_dropped")

			set_dropped_piece(null)
			set_busy(false)


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]
func _on_Piece_dropped(piece: Control) -> void:
	if piece.rect_global_position != self.rect_global_position:
		if piece.is_connected("dropped", self, "_on_Piece_dropped"):
			piece.disconnect("dropped", self, "_on_Piece_dropped")
		set_dropped_piece(null)
		set_busy(false)

	
#	print("\nself: ", self)
#	print("drop:busy: ", get_busy())
#	print("drop:piece: ", get_dropped_piece())

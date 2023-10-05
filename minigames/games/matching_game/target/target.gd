#tool
#class_name Name #, res://class_name_icon.svg
extends TextureRect


#  [DOCSTRING]


#  [SIGNALS]
signal was_combined
signal attempt_to_combine


#  [ENUMS]
enum State {INCOMPLETE, COMPLETE}


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _current_state: int = State.INCOMPLETE \
		setget set_current_state, get_current_state

var _matching_id: int = int(0) \
		setget set_matching_id, get_matching_id

var _subtitle: String = String("") \
		setget set_subtitle, get_subtitle


#  [ONREADY_VARIABLES]
onready var subtitle: Label = $Label


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	subtitle.visible = false


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_current_state(new_value: int) -> void:
	_current_state = new_value
	
	match(_current_state):
		
		State.INCOMPLETE:
			subtitle.visible = false
			subtitle.text = ""
			set("self_modulate", Color(1.0, 1.0, 1.0, 1.0))
			
		State.COMPLETE:
			subtitle.visible = true
			set("self_modulate", Color(1.0, 1.0, 1.0, 0.5))


func get_current_state() -> int:
	return _current_state


func set_matching_id(new_value: int) -> void:
	_matching_id = new_value


func get_matching_id() -> int:
	return _matching_id


func set_subtitle(new_value: String) -> void:
	_subtitle = new_value
	
	subtitle.text = _subtitle


func get_subtitle() -> String:
	return _subtitle


func create(image: ImageTexture, matching_id: int, subtitle: String = String("")) -> void:
	texture = image
	set_matching_id(matching_id)
	set_subtitle(subtitle)


func can_drop_data(position: Vector2, data) -> bool:
	if get_current_state() == State.INCOMPLETE:
		return true
	else:
		return false


func drop_data(position: Vector2, data: Dictionary) -> void:
	if get_current_state() == State.INCOMPLETE:
		if data.has("matching_id"):
			if get_matching_id() == data["matching_id"]:
				self.set_current_state(State.COMPLETE)
				data["bullet"].set_current_state(State.COMPLETE)
				emit_signal("was_combined")
			else:
				emit_signal("attempt_to_combine")


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

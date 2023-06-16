#tool
#class_name Name #, res://class_name_icon.svg
extends CanvasLayer


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]
enum State {WAIT, DRAWING}


#  [CONSTANTS]
const FIRST_POINT: int = 0
const LAST_POINT: int = 1


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _draw_line: bool = false \
		setget set_draw_line, get_draw_line

var _current_line: Line2D = null \
		setget set_current_line, get_current_line

var _state: int = State.WAIT \
		setget set_state, get_state


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
#func _ready() -> void:
#	pass


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
func _process(_delta: float) -> void:
	if get_draw_line():
		if get_current_line() != null:
			var mouse_position: Vector2 = get_tree().get_root().get_mouse_position()
			get_current_line().set_point_position(LAST_POINT, mouse_position)


#  [PUBLIC_METHODS]
func set_draw_line(new_value: bool) -> void:
	_draw_line = new_value


func get_draw_line() -> bool:
	return _draw_line


func set_current_line(new_value: Line2D) -> void:
	_current_line = new_value


func get_current_line() -> Line2D:
	return _current_line


func set_state(new_value: int) -> void:
	_state = new_value


func get_state() -> int:
	return _state


func add_first_point(new_position: Vector2) -> void:
	var line_2d: Line2D = Line2D.new()
	line_2d.set_width(30.0)
	var color: Color = API.theme.get_color(API.theme.PB)
	color.a = 0.5
	line_2d.default_color = color
	line_2d.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line_2d.end_cap_mode = Line2D.LINE_CAP_ROUND
	add_child(line_2d)
	set_current_line(line_2d)
	get_current_line().add_point(new_position)
	get_current_line().add_point(new_position)
	set_draw_line(true)
	set_state(State.DRAWING)


func add_last_point(new_position: Vector2) -> void:
	set_draw_line(false)
	set_state(State.WAIT)
	get_current_line().set_point_position(LAST_POINT, new_position)
	set_current_line(null)


#  [PRIVATE_METHODS]


#  [SIGNAL_METHODS]

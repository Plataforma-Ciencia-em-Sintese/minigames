class_name ResponsiveLine2D
extends Node2D


const FIRST_POINT: int = 0
const LAST_POINT: int = 1


var _line: Line2D = null
var _first_reference: Node = null
var _last_reference: Node = null


func _init() -> void:
	_line = Line2D.new()
	add_child(_line)
	_line.set_default_color(Color(0.5, 0.5, 0.5, 0.5))
	_line.set_width(46.0)
	_line.set_begin_cap_mode(Line2D.LINE_CAP_ROUND)
	_line.set_end_cap_mode(Line2D.LINE_CAP_ROUND)



func add_first_reference(node: Node) -> void:
	var position: Vector2 = Vector2.ZERO
	position = node.get_global_rect().position + node.rect_size/2
	_line.add_point(position)
	_line.add_point(position)
	_first_reference = node


func add_last_reference(node: Node) -> void:
	var position: Vector2 = Vector2.ZERO
	position = node.get_global_rect().position + node.rect_size/2
	_line.set_point_position(LAST_POINT, position)
	_last_reference = node


func change_color(color: Color, alpha: float = 0.5) -> void:
	color.a = alpha
	_line.default_color = color


func recalculate_positions() -> void:
	var position: Vector2 = Vector2.ZERO

	if _first_reference != null:
		position = _first_reference.get_global_rect().position + \
				_first_reference.rect_size/2
		_line.set_point_position(FIRST_POINT, position)

	if _last_reference != null:
		position = _last_reference.get_global_rect().position + \
				_last_reference.rect_size/2
		_line.set_point_position(LAST_POINT, position)




class_name LineMaker2D
extends CanvasLayer


enum ThemeColor {
	RED = 0,
	GREEN = 1,
	THEME = 2
}


var _current_line: ResponsiveLine2D = null
var _first_point_added: bool = false
var _last_point_added: bool = false
var _mouse_pressed: bool = false
var _fake_values: bool = false
var _word_found: bool = false


func _ready() -> void:
	if get_name() == get_tree().get_current_scene().get_name():
		_fake_values = true

	get_tree().get_root().connect("size_changed", self, "_on_size_changed")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			_mouse_pressed = true
		else:
			_mouse_pressed = false
			if _first_point_added and _last_point_added:
				if _word_found:
					_current_line = null
					remove_current_line()
				else:
					remove_current_line()

			elif _first_point_added and not _last_point_added:
				remove_current_line()


func remove_current_line() -> void:
	_first_point_added = false
	_last_point_added = false
	remove_child(_current_line)
	if _current_line != null:
		_current_line.queue_free()
		_current_line = null


func add_first_point(reference_position: Node) -> void:
	_current_line = ResponsiveLine2D.new()
	add_child(_current_line)
	_current_line.add_first_reference(reference_position)
#	change_color_on_current_line(ThemeColor.RED)
	_first_point_added = true


func add_last_point(reference_position: Node) -> void:
	if _current_line != null:
		_current_line.add_last_reference(reference_position)
		_last_point_added = true


func add_permanent_line(start: Node, end: Node) -> void:
	var line = ResponsiveLine2D.new()
	add_child(line)
	line.add_first_reference(start)
	line.add_last_reference(end)
	var color: Color = API.theme.get_color(API.theme.PB)
	color.a = 0.5
	line.change_color(color)


func change_color_on_current_line(reference: int) -> void:
	if _current_line != null:
		var color: Color = Color.black

		match reference:
			ThemeColor.RED:
				if _fake_values:
					color = Color.red
				else:
					color = API.theme.get_color(API.theme.RED)

			ThemeColor.GREEN:
				if _fake_values:
					color = Color.green
				else:
					color = API.theme.get_color(API.theme.GREEN)

			ThemeColor.THEME:
				if _fake_values:
					color = Color.green
				else:
					color = API.theme.get_color(API.theme.PB)

		color.a = 0.5
		_current_line.change_color(color)


func _on_size_changed():
	for child in get_children():
		if child is ResponsiveLine2D:
			child.recalculate_positions()




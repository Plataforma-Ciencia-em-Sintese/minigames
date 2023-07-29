class_name GridLabelItem
extends Label


signal item_has_selected(slot)
signal item_has_deselected(slot)


var _emitted_selected: bool = false


func _process(_delta: float) -> void:
	if is_mouse_pressed_on_item():
		if not is_emitted_selected():
			_emitted_selected = true
			emit_signal("item_has_selected", self)
#			print(text + ": selecionado!")
	else:
		if is_emitted_selected() and not Input.is_mouse_button_pressed(BUTTON_LEFT):
			_emitted_selected = false
			emit_signal("item_has_deselected", self)
#			print(text + ": desselecionado!")


func is_mouse_pressed_on_item() -> bool:
	if Rect2(Vector2.ZERO, rect_size).has_point(get_local_mouse_position()):
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			return true
	return false


func reset_emitted_selected() -> void:
	 _emitted_selected = false


func is_emitted_selected() -> bool:
	return _emitted_selected


func get_index_in_parent() -> int:
	if get_parent() is GridContainer:
		return int(get_parent().get_node(get_name()).get_index())
	return -1


func get_row_in_parent() -> int:
	if get_parent() is GridContainer:
		return int(get_parent().get_node(get_name()).get_index() / get_parent().get_columns())
	return -1


func get_column_in_parent() -> int:
	if get_parent() is GridContainer:
		return int(get_parent().get_node(get_name()).get_index() % get_parent().get_columns())
	return -1


func get_parent_size() -> int:
	if get_parent() is GridContainer:
		return int(get_parent().get_children().size())
	return -1


func get_parent_rows() -> int:
	if get_parent() is GridContainer:
		return int(get_parent().get_children().size() / get_parent().get_columns())
	return -1


func get_parent_columns() -> int:
	if get_parent() is GridContainer:
		return int(get_parent().get_columns())
	return -1


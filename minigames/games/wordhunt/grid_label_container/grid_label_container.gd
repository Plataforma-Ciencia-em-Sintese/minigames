extends GridContainer


signal selected_word(word)
signal first_letter_selected(letter)
signal end_letter_selected(letter)


const COLOR_DIRECTION_HORIZONTAL: Color = Color("#98c0f0")
const COLOR_DIRECTION_HORIZONTAL_REVERSE: Color = Color("#1a5fb3")
const COLOR_DIRECTION_VERTICAL: Color = Color("#f4c111")
const COLOR_DIRECTION_VERTICAL_REVERSE: Color = Color("#e56000")
const COLOR_DIRECTION_DIAGONAL_RIGHT: Color = Color("#26a269")
const COLOR_DIRECTION_DIAGONAL_RIGHT_REVERSE: Color = Color("#8ff0a4")
const COLOR_DIRECTION_DIAGONAL_LEFT: Color = Color("#cdab8f")
const COLOR_DIRECTION_DIAGONAL_LEFT_REVERSE: Color = Color("#63452c")

const DIRECTION_HORIZONTAL = 1
const DIRECTION_HORIZONTAL_REVERSE = 2
const DIRECTION_VERTICAL = 3
const DIRECTION_VERTICAL_REVERSE = 4
const DIRECTION_DIAGONAL_RIGHT = 5
const DIRECTION_DIAGONAL_RIGHT_REVERSE = 6
const DIRECTION_DIAGONAL_LEFT = 7
const DIRECTION_DIAGONAL_LEFT_REVERSE = 8


const _GridLabelItem: PackedScene = preload("res://games/wordhunt/grid_label_item/grid_label_item.tscn")


var _grid_generator: WordhuntGridGenerator = WordhuntGridGenerator.new()
var _first_item: GridLabelItem = null
var _end_item: GridLabelItem = null
var _current_direction = null
var _paint: bool = false
var _word: String = ""


func _ready() -> void:
	var new_grid: Array = _grid_generator.generate_grid(API.game.get_words().keys())
	insert_letters_into_grid(new_grid)


func insert_letters_into_grid(matrix_letters: Array) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	for row in matrix_letters.size():
		for col in matrix_letters[0].size():
			var new_letter: GridLabelItem = _GridLabelItem.instance()
			new_letter.set_text(matrix_letters[row][col])
			add_child(new_letter)
			new_letter.connect("item_has_selected", self, "_on_item_has_selected")
			new_letter.connect("item_has_deselected", self, "_on_item_has_deselected")


func selected_first_item(item: GridLabelItem) -> void:
	if _paint:
		item.set("custom_colors/font_color", Color.red)
		paint_intermediate_items()


func selected_end_item(item: GridLabelItem) -> void:
	if _paint:
		item.set("custom_colors/font_color", Color.red)


func paint_intermediate_items() -> void:
	if _paint:
		var first_item_row: int = _first_item.get_row_in_parent()
		var first_item_column: int = _first_item.get_column_in_parent()

		for child in get_children():
			if child != _first_item:
				var child_row: int = child.get_row_in_parent()
				var child_column: int = child.get_column_in_parent()
				var row_difference = child_row - first_item_row
				var column_difference = child_column - first_item_column

				# DIAGONAL
				if abs(row_difference) == abs(column_difference):

					# DIRECTION_DIAGONAL_RIGHT
					if row_difference > 0 and column_difference > 0:
						child.set("custom_colors/font_color", COLOR_DIRECTION_DIAGONAL_RIGHT)

					# DIRECTION_DIAGONAL_RIGHT_REVERSE
					elif row_difference < 0 and column_difference < 0:
						child.set("custom_colors/font_color", COLOR_DIRECTION_DIAGONAL_RIGHT_REVERSE)

					# DIRECTION_DIAGONAL_LEFT
					elif row_difference > 0 and column_difference < 0:
						child.set("custom_colors/font_color", COLOR_DIRECTION_DIAGONAL_LEFT)

					# DIRECTION_DIAGONAL_LEFT_REVERSE
					elif row_difference < 0 and column_difference > 0:
						child.set("custom_colors/font_color", COLOR_DIRECTION_DIAGONAL_LEFT_REVERSE)

				# HORIZONTAL AND VERTICAL
				else:

					# DIRECTION_HORIZONTAL
					if child_row == first_item_row and child_column >= first_item_column:
						child.set("custom_colors/font_color", COLOR_DIRECTION_HORIZONTAL)

					# DIRECTION_HORIZONTAL_REVERSE
					if child_row == first_item_row and child_column <= first_item_column:
						child.set("custom_colors/font_color", COLOR_DIRECTION_HORIZONTAL_REVERSE)

					# DIRECTION_VERTICAL
					if child_row >= first_item_row and child_column == first_item_column:
						child.set("custom_colors/font_color", COLOR_DIRECTION_VERTICAL)

					# DIRECTION_VERTICAL_REVERSE
					if child_row <= first_item_row and child_column == first_item_column:
						child.set("custom_colors/font_color", COLOR_DIRECTION_VERTICAL_REVERSE)


func calculate_direction_item(item: GridLabelItem) -> int:
	var first_item_row: int = _first_item.get_row_in_parent()
	var first_item_column: int = _first_item.get_column_in_parent()
	var item_row: int = item.get_row_in_parent()
	var item_column: int = item.get_column_in_parent()
	var row_difference = item_row - first_item_row
	var column_difference = item_column - first_item_column

	if item != _first_item:

		# DIAGONAL
		if abs(row_difference) == abs(column_difference):
			# O item está em uma das diagonais

			# DIRECTION_DIAGONAL_RIGHT
			if row_difference > 0 and column_difference > 0:
				return DIRECTION_DIAGONAL_RIGHT

			# DIRECTION_DIAGONAL_RIGHT_REVERSE
			elif row_difference < 0 and column_difference < 0:
				return DIRECTION_DIAGONAL_RIGHT_REVERSE

			# DIRECTION_DIAGONAL_LEFT
			elif row_difference > 0 and column_difference < 0:
				return DIRECTION_DIAGONAL_LEFT

			# DIRECTION_DIAGONAL_LEFT_REVERSE
			elif row_difference < 0 and column_difference > 0:
				return DIRECTION_DIAGONAL_LEFT_REVERSE

		# HORIZONTAL AND VERTICAL
		else:

			# DIRECTION_HORIZONTAL
			if item_row == first_item_row and item_column >= first_item_column:
				return DIRECTION_HORIZONTAL

			# DIRECTION_HORIZONTAL_REVERSE
			if item_row == first_item_row and item_column <= first_item_column:
				return DIRECTION_HORIZONTAL_REVERSE

			# DIRECTION_VERTICAL
			if item_row >= first_item_row and item_column == first_item_column:
				return DIRECTION_VERTICAL

			# DIRECTION_VERTICAL_REVERSE
			if item_row <= first_item_row and item_column == first_item_column:
				return DIRECTION_VERTICAL_REVERSE

	return -1


func select_items_along_line(first_item: GridLabelItem, last_item: GridLabelItem) -> void:
	var first_item_row: int = first_item.get_row_in_parent()
	var first_item_column: int = first_item.get_column_in_parent()
	var last_item_row: int = last_item.get_row_in_parent()
	var last_item_column: int = last_item.get_column_in_parent()

	var column_distance = abs(last_item_column - first_item_column)
	var row_distance = abs(last_item_row - first_item_row)
	var step_x = 1 if first_item_column < last_item_column else -1
	var step_y = 1 if first_item_row < last_item_row else -1
	var error = column_distance - row_distance

	var selected_letters: String = ""
	while true:
		var current_item: GridLabelItem = get_item_at_position(first_item_row, first_item_column)
		if _paint:
			current_item.set("custom_colors/font_color", Color.red)

		selected_letters += current_item.text

		# Check if we arrived at the last item
		if first_item_column == last_item_column and first_item_row == last_item_row:
			break

		var double_error = 2 * error
		if double_error > -row_distance:
			error -= row_distance
			first_item_column += step_x
		if double_error < column_distance:
			error += column_distance
			first_item_row += step_y

	if _word != selected_letters:
		_word = selected_letters
		emit_signal("selected_word", _word)


func get_item_at_position(row: int, column: int) -> GridLabelItem:
	for child in get_children():
		if child.get_row_in_parent() == row and child.get_column_in_parent() == column:
			return child
	return null


func _on_item_has_selected(item: GridLabelItem) -> void:
	if _first_item == null:

		_first_item = item
		_word = _first_item.text

		selected_first_item(_first_item)
		emit_signal("selected_word", _word)
		emit_signal("first_letter_selected", _first_item)

	else:

		var direction: int = calculate_direction_item(item)
		if direction != -1:

			_current_direction = direction
			_end_item = item

			for child in get_children():
				if child != _first_item:
					child.reset_emitted_selected()
					if _paint:
						child.set("custom_colors/font_color", Color.black)

			selected_end_item(_end_item)
			emit_signal("end_letter_selected", _end_item)

			paint_intermediate_items()
			select_items_along_line(_first_item, _end_item)




func _on_item_has_deselected(item: GridLabelItem) -> void:
	if item == _first_item:
		_first_item = null
		_end_item = null
		_current_direction = null

	if _paint:
		for child in get_children():
			child.set("custom_colors/font_color", Color.black)

	_word = ""
	emit_signal("selected_word", _word)


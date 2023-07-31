extends GridContainer


signal selected_word(word)
signal first_letter_selected(letter)
signal last_letter_selected(letter)
signal selection_finish(first_letter, last_letter, word)


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
var _first_letter: GridLabelItem = null
var _last_letter: GridLabelItem = null
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
			new_letter.connect("letter_has_selected", self, "_on_letter_has_selected")
			new_letter.connect("letter_has_deselected", self, "_on_letter_has_deselected")


func selected_first_letter(letter: GridLabelItem) -> void:
	if _paint:
		letter.set("custom_colors/font_color", Color.red)
		paint_intermediate_letters()


func selected_last_letter(letter: GridLabelItem) -> void:
	if _paint:
		letter.set("custom_colors/font_color", Color.red)


func paint_intermediate_letters() -> void:
	if _paint:
		var first_letter_row: int = _first_letter.get_row_in_parent()
		var first_letter_column: int = _first_letter.get_column_in_parent()

		for child in get_children():
			if child != _first_letter:
				var child_row: int = child.get_row_in_parent()
				var child_column: int = child.get_column_in_parent()
				var row_difference = child_row - first_letter_row
				var column_difference = child_column - first_letter_column

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
					if child_row == first_letter_row and child_column >= first_letter_column:
						child.set("custom_colors/font_color", COLOR_DIRECTION_HORIZONTAL)

					# DIRECTION_HORIZONTAL_REVERSE
					if child_row == first_letter_row and child_column <= first_letter_column:
						child.set("custom_colors/font_color", COLOR_DIRECTION_HORIZONTAL_REVERSE)

					# DIRECTION_VERTICAL
					if child_row >= first_letter_row and child_column == first_letter_column:
						child.set("custom_colors/font_color", COLOR_DIRECTION_VERTICAL)

					# DIRECTION_VERTICAL_REVERSE
					if child_row <= first_letter_row and child_column == first_letter_column:
						child.set("custom_colors/font_color", COLOR_DIRECTION_VERTICAL_REVERSE)


func calculate_direction_letter(letter: GridLabelItem) -> int:
	var first_letter_row: int = _first_letter.get_row_in_parent()
	var first_letter_column: int = _first_letter.get_column_in_parent()
	var letter_row: int = letter.get_row_in_parent()
	var letter_column: int = letter.get_column_in_parent()
	var row_difference = letter_row - first_letter_row
	var column_difference = letter_column - first_letter_column

	if letter != _first_letter:

		# DIAGONAL
		if abs(row_difference) == abs(column_difference):
			# O letter está em uma das diagonais

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
			if letter_row == first_letter_row and letter_column >= first_letter_column:
				return DIRECTION_HORIZONTAL

			# DIRECTION_HORIZONTAL_REVERSE
			if letter_row == first_letter_row and letter_column <= first_letter_column:
				return DIRECTION_HORIZONTAL_REVERSE

			# DIRECTION_VERTICAL
			if letter_row >= first_letter_row and letter_column == first_letter_column:
				return DIRECTION_VERTICAL

			# DIRECTION_VERTICAL_REVERSE
			if letter_row <= first_letter_row and letter_column == first_letter_column:
				return DIRECTION_VERTICAL_REVERSE

	return -1


func select_letters_along_line(first_letter: GridLabelItem, last_letter: GridLabelItem) -> void:
	var first_letter_row: int = first_letter.get_row_in_parent()
	var first_letter_column: int = first_letter.get_column_in_parent()
	var last_letter_row: int = last_letter.get_row_in_parent()
	var last_letter_column: int = last_letter.get_column_in_parent()

	var column_distance = abs(last_letter_column - first_letter_column)
	var row_distance = abs(last_letter_row - first_letter_row)
	var step_x = 1 if first_letter_column < last_letter_column else -1
	var step_y = 1 if first_letter_row < last_letter_row else -1
	var error = column_distance - row_distance

	var selected_letters: String = ""
	while true:
		var current_letter: GridLabelItem = get_letter_at_position(first_letter_row, first_letter_column)
		if _paint:
			current_letter.set("custom_colors/font_color", Color.red)

		selected_letters += current_letter.text

		# Check if we arrived at the last letter
		if first_letter_column == last_letter_column and first_letter_row == last_letter_row:
			break

		var double_error = 2 * error
		if double_error > -row_distance:
			error -= row_distance
			first_letter_column += step_x
		if double_error < column_distance:
			error += column_distance
			first_letter_row += step_y

	if _word != selected_letters:
		_word = selected_letters
		emit_signal("selected_word", _word)


func get_letter_at_position(row: int, column: int) -> GridLabelItem:
	for child in get_children():
		if child.get_row_in_parent() == row and child.get_column_in_parent() == column:
			return child
	return null


func _on_letter_has_selected(letter: GridLabelItem) -> void:
	if _first_letter == null:

		_first_letter = letter
		_word = _first_letter.text

		selected_first_letter(_first_letter)
		emit_signal("selected_word", _word)
		emit_signal("first_letter_selected", _first_letter)

	else:

		var direction: int = calculate_direction_letter(letter)
		if direction != -1:

			_current_direction = direction
			_last_letter = letter

			for child in get_children():
				if child != _first_letter:
					child.reset_emitted_selected()
					if _paint:
						child.set("custom_colors/font_color", Color.black)

			selected_last_letter(_last_letter)
			emit_signal("last_letter_selected", _last_letter)

			paint_intermediate_letters()
			select_letters_along_line(_first_letter, _last_letter)




func _on_letter_has_deselected(letter: GridLabelItem) -> void:
	var first_letter: GridLabelItem = _first_letter
	var last_letter: GridLabelItem = _last_letter
	var word: String = _word
	emit_signal("selection_finish", first_letter, last_letter, word)

	if letter == _first_letter:
		_first_letter = null
		_last_letter = null
		_current_direction = null

	if _paint:
		for child in get_children():
			child.set("custom_colors/font_color", Color.black)

	_word = ""
	emit_signal("selected_word", _word)


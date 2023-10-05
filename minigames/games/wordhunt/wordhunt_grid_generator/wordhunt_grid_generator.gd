class_name WordhuntGridGenerator
extends Resource


const ROWS: int = 16
const COLUMNS: int = 18
const GRID_SLOTS: int = ROWS * COLUMNS
const EMPTY_LETTER: String = "@"


var _grid: Array = []
var _words: Array = []


func generate_grid(words: Array) -> Array:
	if not words.empty():
		for i in range(0, words.size()):
			_words.append(sanitization_rules(words[i]))

		randomize()

		initialize_grid()
		insert_words()
		fill_empty_spaces()

		#_print_grid()

		return _grid

	return []


func sanitization_rules(word: String) -> String:
	var sanitized_word: String = word

	sanitized_word = StringHandler.remove_accent(sanitized_word)
	sanitized_word = StringHandler.removes_special_characters(sanitized_word)
	sanitized_word = sanitized_word.to_upper()

	return sanitized_word


func initialize_grid() -> Array:
	_grid = []
	for _i in range(ROWS):
		var row = []
		for _ii in range(COLUMNS):
			row.append(EMPTY_LETTER)
		_grid.append(row)

	return _grid


func insert_words() -> Array:
	for word in _words:
		var inserted = false
		while not inserted:
			var row = randi() % ROWS
			var col = randi() % COLUMNS
			var direction = randi() % 4  # 0: vertical, 1: horizontal, 2: diagonal-up, 3: diagonal-down

			if check_position_validity(word, row, col, direction):
				insert_word_at_position(word, row, col, direction)
				inserted = true

	return _grid


func check_position_validity(word: String, row: int, col: int, direction: int) -> bool:
	var word_length = word.length()

	if direction == 0:  # vertical
		if row + word_length <= ROWS:
			for i in range(word_length):
				var grid_letter = _grid[row + i][col]
				var word_letter = word[i]
				if grid_letter != EMPTY_LETTER and grid_letter != word_letter:
					return false
		else:
			return false

	if direction == 1:  # horizontal
		if col + word_length <= COLUMNS:
			for i in range(word_length):
				var grid_letter = _grid[row][col + i]
				var word_letter = word[i]
				if grid_letter != EMPTY_LETTER and grid_letter != word_letter:
					return false
		else:
			return false

	if direction == 2:  # diagonal-up
		if row - word_length >= -1 and col + word_length <= COLUMNS:
			for i in range(word_length):
				var grid_letter = _grid[row - i][col + i]
				var word_letter = word[i]
				if grid_letter != EMPTY_LETTER and grid_letter != word_letter:
					return false
		else:
			return false

	if direction == 3:  # diagonal-down
		if row + word_length <= ROWS and col + word_length <= COLUMNS:
			for i in range(word_length):
				var grid_letter = _grid[row + i][col + i]
				var word_letter = word[i]
				if grid_letter != EMPTY_LETTER and grid_letter != word_letter:
					return false
		else:
			return false

	return true


func insert_word_at_position(word: String, row: int, col: int, direction: int) -> Array:
	var word_length = word.length()

	if direction == 0:  # vertical
		for i in range(word_length):
			_grid[row + i][col] = word[i]

	if direction == 1:  # horizontal
		for i in range(word_length):
			_grid[row][col + i] = word[i]

	if direction == 2:  # diagonal-up
		for i in range(word_length):
			_grid[row - i][col + i] = word[i]

	if direction == 3:  # diagonal-down
		for i in range(word_length):
			_grid[row + i][col + i] = word[i]

	return _grid


func fill_empty_spaces() -> Array:
	for row in range(ROWS):
		for col in range(COLUMNS):
			if _grid[row][col] == EMPTY_LETTER:
				_grid[row][col] = StringHandler.random_letter(true)

	return _grid


func _print_grid() -> void:
	for _i in range(ROWS):
		var row_str = ""
		for _ii in range(COLUMNS):
			row_str += str(_grid[_i][_ii])
		print(row_str)

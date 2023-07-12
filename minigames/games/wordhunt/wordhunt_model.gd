#tool
#class_name Name #, res://class_name_icon.svg
extends EditorScript


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]
const ROWS: int = 16
const COLUMNS: int = 18

const _GRID_SLOTS: int = ROWS * COLUMNS
const _EMPTY_LETTER: String = "@"

const _LETTER_SLOT: PackedScene = preload("res://games/wordhunt/letter_slot/letter_slot.tscn")
const _WORD_TIP: PackedScene = preload("res://games/wordhunt/word_tip/word_tip.tscn")


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _grid: Array = []
var _words: Array = [
	"ABACAXI",
	"LARANJA",
	"LIMAO",
	"MELANCIA",
	"BANANA",
	"MORANGO",
	"UVA",
	"MACA",
	"PERA",
	"MANGA"
]


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _run() -> void:
	generate_grid(_words)


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func generate_grid(words: Array) -> Array:
	if not words.empty():
		for i in range(0, words.size() - 1):
			_words.append(_remove_replace_and_upper_case_chars(words[i]))

		randomize()

		_initialize_grid()
		_insert_words()

		_fill_empty_spaces()

		_print_grid()

		return _grid

	return []



#  [PRIVATE_METHODS]
func _remove_replace_and_upper_case_chars(default_string: String) -> String:
	var accent_map: Dictionary = {
		"á": "a", "à": "a", "ã": "a", "â": "a", "ä": "a",
		"é": "e", "è": "e", "ê": "e", "ë": "e",
		"í": "i", "ì": "i", "î": "i", "ï": "i",
		"ó": "o", "ò": "o", "õ": "o", "ô": "o", "ö": "o",
		"ú": "u", "ù": "u", "û": "u", "ü": "u",
		"ç": "c",
		"Á": "A", "À": "A", "Ã": "A", "Â": "A", "Ä": "A",
		"É": "E", "È": "E", "Ê": "E", "Ë": "E",
		"Í": "I", "Ì": "I", "Î": "I", "Ï": "I",
		"Ó": "O", "Ò": "O", "Õ": "O", "Ô": "O", "Ö": "O",
		"Ú": "U", "Ù": "U", "Û": "U", "Ü": "U",
		"Ç": "C"
	}

	var string_without_accent: String = ""
	for letter in default_string:
		if accent_map.has(letter):
			string_without_accent += accent_map[letter]
		else:
			string_without_accent += letter

	var result_string: String = string_without_accent
	var remove_chars: = " !-#$?()[]*+.,"
	for i in range(0, len(remove_chars)):
		result_string = result_string.replace(remove_chars[i],"")

	return result_string.to_upper()



func _initialize_grid() -> void:
	_grid = []
	for _i in range(ROWS):
		var row = []
		for _ii in range(COLUMNS):
			row.append(_EMPTY_LETTER)
		_grid.append(row)


func _insert_words() -> void:
		for word in _words:
			var inserted = false
			while not inserted:
				var row = randi() % ROWS
				var col = randi() % COLUMNS
				var direction = randi() % 4  # 0: vertical, 1: horizontal, 2: diagonal-up, 3: diagonal-down

				if _check_position_validity(word, row, col, direction):
					_insert_word_at_position(word, row, col, direction)
					inserted = true


func _check_position_validity(word: String, row: int, col: int, direction: int) -> bool:
	var word_length = word.length()

	if direction == 0:  # vertical
		if row + word_length <= ROWS:
			for i in range(word_length):
				var grid_letter = _grid[row + i][col]
				var word_letter = word[i]
				if grid_letter != _EMPTY_LETTER and grid_letter != word_letter:
					return false
		else:
			return false

	if direction == 1:  # horizontal
		if col + word_length <= COLUMNS:
			for i in range(word_length):
				var grid_letter = _grid[row][col + i]
				var word_letter = word[i]
				if grid_letter != _EMPTY_LETTER and grid_letter != word_letter:
					return false
		else:
			return false

	if direction == 2:  # diagonal-up
		if row - word_length >= -1 and col + word_length <= COLUMNS:
			for i in range(word_length):
				var grid_letter = _grid[row - i][col + i]
				var word_letter = word[i]
				if grid_letter != _EMPTY_LETTER and grid_letter != word_letter:
					return false
		else:
			return false

	if direction == 3:  # diagonal-down
		if row + word_length <= ROWS and col + word_length <= COLUMNS:
			for i in range(word_length):
				var grid_letter = _grid[row + i][col + i]
				var word_letter = word[i]
				if grid_letter != _EMPTY_LETTER and grid_letter != word_letter:
					return false
		else:
			return false

	return true


func _insert_word_at_position(word: String, row: int, col: int, direction: int) -> void:
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


func _fill_empty_spaces() -> void:
	for row in range(ROWS):
		for col in range(COLUMNS):
			if _grid[row][col] == _EMPTY_LETTER:
				_grid[row][col] = _random_letter()


func _random_letter() -> String:
	# ASCII codes
	# "a" for lowercase letters
	# "A" for uppercase letters
	var ascii_code = ord("a") + randi() % 26
	return char(ascii_code)


func _print_grid() -> void:
	for _i in range(ROWS):
		var row_str = ""
		for _ii in range(COLUMNS):
			row_str += str(_grid[_i][_ii])
		print(row_str)


#  [SIGNAL_METHODS]

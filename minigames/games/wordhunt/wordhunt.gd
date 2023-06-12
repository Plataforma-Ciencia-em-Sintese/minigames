#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]
const ROWS: int = 16
const COLUMNS: int = 19
const EMPTY_LETTER: String = "@"
const WORDS: Array = ["ABACAXI", "LARANJA", "LIMAO", "MELANCIA", "BANANA", "MORANGO", "UVA", "MACA", "PERA", "MANGA"]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _grid: Array = [] \
		setget set_grid, get_grid


#  [ONREADY_VARIABLES]
onready var grid_container: GridContainer = $"%GridContainer"


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	randomize()
	_initialize_grid()
	_insert_words()
	_fill_empty_spaces()
#	_print_grid()
#	_save_grid_to_file("wordhunt.txt")
	_initialize_ui_grid()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_grid(new_value: Array) -> void:
	_grid = new_value


func get_grid() -> Array:
	return _grid


#  [PRIVATE_METHODS]
func _initialize_grid():
	set_grid([])
	for i in range(ROWS):
		var row = []
		for j in range(COLUMNS):
			row.append(EMPTY_LETTER)
		get_grid().append(row)


func _insert_words() -> void:
	for word in WORDS:
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
				var grid_letter = get_grid()[row + i][col]
				var word_letter = word[i]
				if grid_letter != EMPTY_LETTER and grid_letter != word_letter:
					return false
		else:
			return false

	if direction == 1:  # horizontal
		if col + word_length <= COLUMNS:
			for i in range(word_length):
				var grid_letter = get_grid()[row][col + i]
				var word_letter = word[i]
				if grid_letter != EMPTY_LETTER and grid_letter != word_letter:
					return false
		else:
			return false

	if direction == 2:  # diagonal-up
		if row - word_length >= -1 and col + word_length <= COLUMNS:
			for i in range(word_length):
				var grid_letter = get_grid()[row - i][col + i]
				var word_letter = word[i]
				if grid_letter != EMPTY_LETTER and grid_letter != word_letter:
					return false
		else:
			return false

	if direction == 3:  # diagonal-down
		if row + word_length <= ROWS and col + word_length <= COLUMNS:
			for i in range(word_length):
				var grid_letter = get_grid()[row + i][col + i]
				var word_letter = word[i]
				if grid_letter != EMPTY_LETTER and grid_letter != word_letter:
					return false
		else:
			return false

	return true


func _insert_word_at_position(word: String, row: int, col: int, direction: int) -> void:
	var word_length = word.length()

	if direction == 0:  # vertical
		for i in range(word_length):
			get_grid()[row + i][col] = word[i]

	if direction == 1:  # horizontal
		for i in range(word_length):
			get_grid()[row][col + i] = word[i]

	if direction == 2:  # diagonal-up
		for i in range(word_length):
			get_grid()[row - i][col + i] = word[i]

	if direction == 3:  # diagonal-down
		for i in range(word_length):
			get_grid()[row + i][col + i] = word[i]


func _fill_empty_spaces() -> void:
	for row in range(ROWS):
		for col in range(COLUMNS):
			if get_grid()[row][col] == EMPTY_LETTER:
				get_grid()[row][col] = _random_letter()


func _random_letter() -> String:
	var ascii_code = ord("A") + randi() % 26  # ASCII codes for lowercase letters
	return " "#char(ascii_code)


#func _print_grid() -> void:
#	for i in range(ROWS):
#		var row_str = ""
#		for j in range(COLUMNS):
#			row_str += str(get_grid()[i][j])
#		print(row_str)


#func _save_grid_to_file(filename: String) -> void:
#	var file = File.new()
#	if file.open(filename, File.WRITE) == OK:
#		for i in range(ROWS):
#			var row_str = ""
#			for j in range(COLUMNS):
#				row_str += str(grid[i][j])
#			file.store_string(row_str + "\n")
#		file.close()
#		print("Grid saved to file: " + filename)
#	else:
#		print("Failed to save grid to file.")


func _initialize_ui_grid() -> void:
	var count: int = 0
	for row in range(0, ROWS):
		for col in range(0, COLUMNS):
			grid_container.get_child(count).set_text(get_grid()[row][col])
			count += 1

#  [SIGNAL_METHODS]
func _on_Home_pressed() -> void:
	get_tree().change_scene("res://home/home.tscn")

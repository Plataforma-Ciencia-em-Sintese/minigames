#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]
const ROWS: int = 16
const COLUMNS: int = 21
const WORDS: Array = ["abacaxi", "laranja", "limao", "melancia", "banana", "morango", "uva", "maça", "pera", "manga"]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]
var grid: Array = []


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	randomize()
	initialize_grid()
	insert_words()
	fill_empty_spaces()
	print_grid()
#	save_grid_to_file("wordhunt.txt")


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func initialize_grid():
	grid = []
	for i in range(ROWS):
		var row = []
		for j in range(COLUMNS):
			row.append("@")
		grid.append(row)

func insert_words():
	for word in WORDS:
		var inserted = false
		while not inserted:
			var row = randi() % ROWS
			var col = randi() % COLUMNS
			var direction = randi() % 4  # 0: vertical, 1: horizontal, 2: diagonal-up, 3: diagonal-down

			if check_position_validity(word, row, col, direction):
				insert_word_at_position(word, row, col, direction)
				inserted = true

func check_position_validity(word: String, row: int, col: int, direction: int) -> bool:
	var word_length = word.length()

	if direction == 0:  # vertical
		if row + word_length <= ROWS:
			for i in range(word_length):
				var grid_letter = grid[row + i][col]
				var word_letter = word[i]
				if grid_letter != "@" and grid_letter != word_letter:
					return false
		else:
			return false

	if direction == 1:  # horizontal
		if col + word_length <= COLUMNS:
			for i in range(word_length):
				var grid_letter = grid[row][col + i]
				var word_letter = word[i]
				if grid_letter != "@" and grid_letter != word_letter:
					return false
		else:
			return false

	if direction == 2:  # diagonal-up
		if row - word_length >= -1 and col + word_length <= COLUMNS:
			for i in range(word_length):
				var grid_letter = grid[row - i][col + i]
				var word_letter = word[i]
				if grid_letter != "@" and grid_letter != word_letter:
					return false
		else:
			return false

	if direction == 3:  # diagonal-down
		if row + word_length <= ROWS and col + word_length <= COLUMNS:
			for i in range(word_length):
				var grid_letter = grid[row + i][col + i]
				var word_letter = word[i]
				if grid_letter != "@" and grid_letter != word_letter:
					return false
		else:
			return false

	return true

func insert_word_at_position(word: String, row: int, col: int, direction: int):
	var word_length = word.length()

	if direction == 0:  # vertical
		for i in range(word_length):
			grid[row + i][col] = word[i]

	if direction == 1:  # horizontal
		for i in range(word_length):
			grid[row][col + i] = word[i]

	if direction == 2:  # diagonal-up
		for i in range(word_length):
			grid[row - i][col + i] = word[i]

	if direction == 3:  # diagonal-down
		for i in range(word_length):
			grid[row + i][col + i] = word[i]

func fill_empty_spaces():
	for row in range(ROWS):
		for col in range(COLUMNS):
			if grid[row][col] == "@":
				grid[row][col] = random_letter()

func random_letter() -> String:
	var ascii_code = ord("a") + randi() % 26  # ASCII codes for lowercase letters
	return "-"#char(ascii_code)

func print_grid():
	for i in range(ROWS):
		var row_str = ""
		for j in range(COLUMNS):
			row_str += str(grid[i][j])
		print(row_str)

#func save_grid_to_file(filename: String):
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


#  [PRIVATE_METHODS]


#  [SIGNAL_METHODS]












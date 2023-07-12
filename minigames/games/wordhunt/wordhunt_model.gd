#tool
#class_name Name #, res://class_name_icon.svg
extends SceneTree


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]
const ROWS: int = 16
const COLUMNS: int = 18
const GRID_SLOTS: int = ROWS * COLUMNS
const EMPTY_LETTER: String = "@"
const WORDS: Array = ["ABACAXI", "LARANJA", "LIMAO", "MELANCIA", "BANANA", "MORANGO", "UVA", "MACA", "PERA", "MANGA"]
const LETTER_SLOT: PackedScene = preload("res://games/wordhunt/letter_slot/letter_slot.tscn")
const WORD_TIP: PackedScene = preload("res://games/wordhunt/word_tip/word_tip.tscn")


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _grid: Array = [] \
		setget set_grid, get_grid


#  [ONREADY_VARIABLES]
# onready var grid_container: GridContainer = $"%GridContainer"
# onready var line_marker: CanvasLayer = $LineMarker
# onready var tip_list: VBoxContainer = $"%TipList"


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	randomize()
	_initialize_grid()
	_insert_words()
	# _insert_tip_words()
	_fill_empty_spaces()
#	_print_grid()
#	_save_grid_to_file("wordhunt.txt")
	# _initialize_ui_grid()






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
	var list_words: Array = []
	for word in API.game.get_words().keys():
		list_words.append(_remove_replace_and_upper_case_chars(str(word)))

	#	for word in WORDS:
	for word in list_words:
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
	var ascii_code = ord("a") + randi() % 26  # ASCII codes for lowercase letters
	return char(ascii_code)


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



# func _initialize_ui_grid() -> void:
# 	for index in range(0, GRID_SLOTS):
# 		var new_letter_slot: Label = LETTER_SLOT.instance()
# 		# new_letter_slot.connect("pressed", self, "_on_mouse_hover_letter", [new_letter_slot])
# 		grid_container.add_child(new_letter_slot)

# 	var count: int = 0
# 	for row in range(0, ROWS):
# 		for col in range(0, COLUMNS):
# 			grid_container.get_child(count).set_text(get_grid()[row][col])
# 			count += 1


# func _insert_tip_words() -> void:
# 	var words_and_tips: Dictionary = API.game.get_words()
# 	for word in words_and_tips:
# 		var new_word_tip: MarginContainer = WORD_TIP.instance()
# 		tip_list.add_child(new_word_tip)
# 		new_word_tip.set_tip_text(str(words_and_tips.get(word)["clue"]))
# 		new_word_tip.set_letter_counter_text(str(str(word).length()) + " Letras")
# 		new_word_tip.set_word_text(str(word).to_upper())


#  [SIGNAL_METHODS]
# func _on_Home_pressed() -> void:
# 	get_tree().change_scene("res://home/home.tscn")


# func _on_mouse_hover_letter(letter: Label) -> void:
# 	pass
	# print("\nletter: " + letter.text)
	# if Input.is_mouse_button_pressed(BUTTON_LEFT):
	# if line_marker.get_draw_line():
	# 	line_marker.add_last_point(letter.rect_global_position + (letter.rect_size / 2.0))
	# else:
	# 	line_marker.add_first_point(letter.rect_global_position + (letter.rect_size / 2.0))

extends Control


#  [DOCSTRING]


#  [SIGNALS]
signal game_over

#  [ENUMS]
enum FORMAT {WIDER, TALL, SQUARE}
enum SOLVE_TARGET {
	three = 90,
	two = 150,
	one = 240,
}

#  [CONSTANTS]
const RATIO = 1080/840.0
const ALLOWED_KEYS = [81, 87, 69, 82, 84, 89, 85, 73, 79, 80, 65, 83, 68, 70, 71, 72, 74, 75, 76, 90, 88, 67, 86, 66, 78, 77, 59, 16777220]
const SPECIAL_CHAR_DICIO = {'Á': 'A', 'À': 'A', 'Ã': 'A', 'Â': 'A', 'É': 'E', 'È': 'E', 'Ẽ': 'E', 'Ê': 'E', 'Í': 'I', 'Ì': 'I', 'Ĩ': 'I', 'Î': 'I', 'Ó': 'O', 'Ò': 'O', 'Õ': 'O', 'Ô': 'O', 'Ú': 'U', 'Ù': 'U', 'Ũ': 'U', 'Û': 'U', 'Ç': 'C', 'Ñ': 'N', '': ' ', ' ': ' '}
const HOLD_AT_LAST_MSEC = 400

#  [EXPORTED_VARIABLES]
export (NodePath) var gameTable
export (NodePath) var clueDisplay

#  [PUBLIC_VARIABLES]perda de passo impressão 3d


#  [PRIVATE_VARIABLES]
var _sizeX := 0
var _sizeY := 0
var _game_buttons = {}
var _number_labels = {}
var _numbered_clues = {}
var _tips = 10
var _anchor : String = ""
var _target : String = ""
var _click_anchor : String = ""
var _click_second : String = ""
var _click_direction : Vector2 = Vector2.ZERO

var _hold_click : bool = false
var _click_time_msec : int = 0

var _clues: Dictionary = {}
var _display: String = ""

var _pos_x : int
var _pos_y : int

var _allowed_keys := []
var _special_char_dicio := {}
var _capital_letters: Array = []

var _selected_item := "0"
var _last_selected_button
var _solved_itens := {}

#  [ONREADY_VARIABLES]
onready var _gameTable = get_node(gameTable) as GridContainer
onready var _clueDisplay = get_node(clueDisplay) as VBoxContainer
onready var _orientation = _clueDisplay.find_node("Orientation") as RichTextLabel
onready var _clueNumber = _clueDisplay.find_node("Number") as RichTextLabel
onready var _clue = _clueDisplay.find_node("Clue") as RichTextLabel
onready var _run_time: int = 0
onready var _timer_display: Label = $AspectRatioContainer/Separador/HBoxContainer/timer
onready var _congratulation: RichTextLabel = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/CongratulationsContainer/TotalStars
onready var _final_time: Label = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/StatisticsContainer/TimeContainer/TotalTime
onready var _panel_information: Panel = $PanelInformation
onready var _show_result_button: Button = $ShowPanelInformation

onready var _test_button: Button = $AspectRatioContainer/Separador/HBoxContainer/AspectRatioContainer/ThemeButtonIcon

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VIRTUAL_METHOD]
func _ready() -> void:
	_override_theme()
	_bug_show_panel_information()
	
#	print(_allowed_keys)
#	print(_clueDisplay)
#	print(_orientation)
#	print(_clueNumber)
#	print(_clue)

#	_mount_special_char()
#	_mount_valid_keys()
	
#	print(_allowed_keys)
	_read_data()
#	printt(_sizeX, _sizeY)
#	_adjust_size()
#	printt(_sizeX, _sizeY)
	
	
	_populate_table()
	
#	for i in _solved_itens: ##Verifica a formatacao das dicas
#		var al = randi()%2
#		if al == 0:
#			_solved_itens[i] = true
	
	_process_clues()
#	_populate_solved_dict()
#	_verify_endgame()

func _input(event):
	if (event is InputEventMouse):
		event as InputEventMouse
		_anchor = _find_anchor(event)
		var q_click = _quick_click(event)
		var button_clicked = _button_clicked(event)
#		printt("quick click", q_click, "anchor", _anchor)
		if q_click: # caso o jogador segure
			_input_hold_setup(event)
		elif (event.button_mask == 1): # caso o jogador opte por clickar
			_word_validator(button_clicked)
		
		




#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]




#  [PRIVATE_METHODS]

func _find_neighbor(button : String, direction : Vector2) -> String:
	if button in _game_buttons:
		var pos_vect : Vector2 = _game_buttons[button]["position"] + direction
		var pos_name : String = str(pos_vect)
		if pos_name in _game_buttons:
			return pos_name
	return ""

func _get_previous(button) -> String:
	if button in _game_buttons:
		if (_click_second == ""):
			var top = _find_neighbor(button, Vector2.UP)
			var left = _find_neighbor(button, Vector2.LEFT)
			if top == _click_anchor:
				return _click_anchor
			elif left == _click_anchor:
				return _click_anchor
			else:
				return ""
		else:
			var first = _game_buttons[_click_anchor]["position"]
			var secon = _game_buttons[_click_second]["position"]
			return _find_neighbor(button, first-secon)
	else:
		return ""

func _does_button_aligned(button : String) -> bool:
	var direction : Vector2 = _game_buttons[_click_second]["position"] - _game_buttons[_click_anchor]["position"]
	var anchorvec : Vector2 = _game_buttons[_click_anchor]["position"]
	var buttonvec : Vector2 = _game_buttons[button]["position"]
	if direction.x == 0:
		return anchorvec.x == buttonvec.x
	return anchorvec.y == buttonvec.y

func _find_click_row_string(button : String) -> String:
#	var output : String = _game_buttons[button]["letter"]
	var output : String = ""
	var direction : Vector2 = _game_buttons[_click_anchor]["position"] - _game_buttons[_click_second]["position"]
	var act_pos : Vector2 = _game_buttons[button]["position"] - direction
	if _does_button_aligned(button):
		while str(act_pos) != _click_anchor:
			act_pos += direction
			var act_str : String = str(act_pos)
			if (_game_buttons[act_str]["active"] or _game_buttons[act_str]["button"].pressed):
				output = _game_buttons[act_str]["letter"] + output
			else:
				return ""
			
		return output
	return ""

func _word_validator(button : String) -> void:
#	printt(_click_anchor, _click_second)
	if button in _game_buttons:
		if (_click_anchor == ""):
			if _game_buttons[button]["letter"] in _capital_letters:
				_click_anchor = button
			else:
				_clear_pressed()
		elif (_click_second == ""):
			if (_get_previous(button) == _click_anchor):
				_click_second = button
#				print(_find_click_row_string(button))
			else:
				_click_anchor = ""
				_click_second = ""
				_clear_pressed()
				_word_validator(button)
		else:
			var test_output = _find_click_row_string(button)
#			print(test_output)
			if (test_output == ""):
				_click_anchor = ""
				_click_second = ""
				_clear_pressed()
				_word_validator(button)
			else:
				if test_output in _solved_itens:
					if not (_solved_itens[test_output]):
						printt(test_output, _solved_itens[test_output])
						_solved_itens[test_output] = true
						_process_clues()
						var direction : Vector2 = _game_buttons[_click_second]["position"] - _game_buttons[_click_anchor]["position"]
						_draw_arrow(_click_anchor, button, direction, false)
						_verify_endgame()

# Este metodo depende dos atributos _click_time_msec, _hold_click e _force_next
func _quick_click (event : InputEventMouse) -> bool: 
	var time : int = OS.get_ticks_msec()
	if (event.button_mask == 0): # Quando o usuario solta o botao
		if (_hold_click):
			_hold_click = false
			if ((time - _click_time_msec) > HOLD_AT_LAST_MSEC):
				return true
#			else:
#				return false
#		else:
#			return false
		return false
		
		
	elif (not _hold_click and event.button_mask == 1): #Quando o usuario segura o botao
		_click_time_msec = time
		_hold_click = true
		return false
		
		
	else: # quando o usuario ja estava segurando o botao
		if ((time - _click_time_msec) > HOLD_AT_LAST_MSEC):
			return true
		return false

func _find_anchor (event : InputEventMouse) -> String:
	if (event.button_mask == 1):
		if _anchor == "":
			var hovered_button : String = _find_hovered_button(event.get_global_position())
			if hovered_button in _game_buttons:
				if _game_buttons[hovered_button]["letter"] in _capital_letters:
					return hovered_button
				else:
					return "asdf"
			else:
				return "asdf"
		elif _anchor in _game_buttons:
			return _anchor
		else:
			return "asdf"
	elif _hold_click:
		return _anchor
	else:
		return ""

func _button_clicked (event : InputEventMouse) -> String:
	var hovered_button : String = _find_hovered_button(event.get_global_position())
	if hovered_button in _game_buttons:
		return hovered_button
	return ""

func _input_hold_setup (event : InputEventMouse) -> void:
	if (event.button_mask == 1):
		if _anchor == "":
			var hovered_button : String = _find_hovered_button(event.get_global_position())
			if hovered_button in _game_buttons:
				if _game_buttons[hovered_button]["letter"] in _capital_letters:
					_anchor = hovered_button
				else:
					_anchor = "asdf"
			else:
				_anchor = "asdf"
		elif _anchor in _game_buttons:
			var hovered_button : String = _find_hovered_button(event.get_global_position())
			if hovered_button in _game_buttons:
				var anchor_position  : Vector2 = _game_buttons[_anchor]["position"]
				var hovered_position : Vector2 = _game_buttons[hovered_button]["position"]
				var direction : Vector2 = hovered_position-anchor_position
				var angle_a : float = abs(direction.angle_to(Vector2.RIGHT))
				var angle_b : float = abs(direction.angle_to(Vector2.DOWN))
#					printt(anchor_position, hovered_position)
#					printt(angle_a, angle_b)
				var arrow_direction : Vector2
				if angle_a <= angle_b:
					_target = str(Vector2(hovered_position.x, anchor_position.y))
					arrow_direction = Vector2.RIGHT
				elif angle_b <= angle_a:
					_target = str(Vector2(anchor_position.x, hovered_position.y))
					arrow_direction = Vector2.DOWN
				if _target in _game_buttons:
					_clear_pressed()
					_draw_arrow(_anchor, _target, arrow_direction)
	elif (event.button_mask == 0):
#			print(_solved_itens)
		var direction : Vector2
		var arrow_string : String = ""
		if ((_anchor in _game_buttons) and (_target in _game_buttons)):
			if _game_buttons[_anchor]["position"].x == _game_buttons[_target]["position"].x:
				direction = Vector2.DOWN
			else:
				direction = Vector2.RIGHT
			arrow_string = _arrow_to_string(_anchor,_target, direction)
		if arrow_string in _solved_itens:
			if not (_solved_itens[arrow_string]):
				printt(arrow_string, _solved_itens[arrow_string])
				_solved_itens[arrow_string] = true
				_process_clues()
				_draw_arrow(_anchor, _target, direction, false)
				_verify_endgame()
				
		_clear_pressed()
		_anchor = ""

func _override_theme() -> void:
	# Game Table Theme
	var table_theme: Theme
	table_theme = $AspectRatioContainer/Separador/Panel/GameTable.get_theme()
	
	var box
	box = table_theme.get_stylebox("normal", "Button")
	box.bg_color = API.theme.get_color(API.theme.PL3)
	
	box = table_theme.get_stylebox("pressed", "Button")
	box.bg_color = API.theme.get_color(API.theme.SL3)
	
	box = table_theme.get_stylebox("hover", "Button")
	box.bg_color = API.theme.get_color(API.theme.PB)
	box.border_color = API.theme.get_color(API.theme.PD1)
	
	box = table_theme.get_stylebox("disabled", "Button")
	box.bg_color = API.theme.get_color(API.theme.PD2)
	
#	box = table_theme.get_stylebox("normal", "Table")
	
#	table_theme.set_color("font_color", "Button", API.theme.get_color(API.theme.DARKGRAY))
	table_theme.set_color("font_color", "Button", API.theme.get_color(API.theme.PD2))
	table_theme.set_color("font_color_focus", "Button", API.theme.get_color(API.theme.PD2))
	table_theme.set_color("font_color_hover", "Button", API.theme.get_color(API.theme.PD2))
	table_theme.set_color("font_color_pressed", "Button", API.theme.get_color(API.theme.PD2))
	table_theme.set_color("font_color", "Label", API.theme.get_color(API.theme.PB))
	
	# number and clue
	var number: Theme
	var clue: Theme
	var default: Theme
	default = $AspectRatioContainer/Separador/Panel.get_theme()
#	number = $AspectRatioContainer/Separador/Panel/ClueDisplay/ClueContainer/Number.get_theme()
#	clue = $AspectRatioContainer/Separador/Panel/ClueDisplay/ClueContainer/Clue.get_theme()
#	number.set_color("font_color", "Label", API.theme.get_color(API.theme.PL1))
#	clue.set_color("font_color", "Label", API.theme.get_color(API.theme.PL1))

	default.set_color("default_color", "RichTextLabel", API.theme.get_color(API.theme.PB))
	default.set_color("font_color", "Label", API.theme.get_color(API.theme.PD2))
	
	box = default.get_stylebox("normal", "Label")
	box.border_color = API.theme.get_color(API.theme.PD2)
#	printt(default, number, clue)

func _bug_show_panel_information():
	_panel_information.hide()
	_show_result_button.hide()

func _manual_hover(but : Button, pos : Vector2) -> bool:
	var rec: Rect2 = but.get_global_rect()
	if (rec.has_point(pos)):
		return true
	return false

func _find_hovered_button(pos : Vector2) -> String:
	for i in _game_buttons:
		if _manual_hover(_game_buttons[i]["button"], pos):
			return i
	return ""

func _clear_pressed() -> void:
	for i in _game_buttons:
		if _game_buttons[i]["active"]:
			_game_buttons[i]["button"].set_pressed(false)
		else:
			_game_buttons[i]["button"].set_pressed(true)

func _draw_arrow(start: String, end: String, direction:Vector2, active:bool = true) -> void:
	if start in _game_buttons:
		_game_buttons[start]["button"].set_pressed(true)
		if not (active):
#			print("Hummm")
			_game_buttons[start]["active"] = active
		if not start == end:
			var new_start : String = str(_game_buttons[start]["position"] + direction)
			_draw_arrow(new_start, end, direction, active)

func _arrow_to_string(start: String, end: String, direction:Vector2) -> String:
	if start in _game_buttons:
		if start == end:
			return _game_buttons[start]["letter"]
		else:
			var new_start : String = str(_game_buttons[start]["position"] + direction)
			return _game_buttons[start]["letter"] + _arrow_to_string(new_start, end, direction)
	return "qualquercoisa"

func _process_clues() -> void:
	var words : Dictionary = API.get_words()
	var display_text = "\n"
	for i in words:
#		print(words[i])
		if _solved_itens[i]:
			display_text = _place_solved_question(words[i], display_text)
		else:
			display_text = _place_unsolved_question(words[i], display_text)
	_clue.bbcode_text = display_text

func _place_solved_question(entry: Dictionary, text: String) -> String:
	var color_1: Color = API.theme.get_color(API.theme.PB)
	color_1.a = 0.35
	var color_2: Color = API.theme.get_color(API.theme.GREEN)
	var color_3: Color = API.theme.get_color(API.theme.BLACK)
	color_3.a = 0.35
	var out_entry = "[color=#%s]%s[/color]\n[b][color=#%s]%d letras[/color]\t[color=#%s]%s[/color][/b]\n" % [color_3.to_html(), entry["value"], color_1.to_html(), len(entry["key"]), color_2.to_html(), entry["key"]]
	var output = str(text, out_entry)
	return output

func _place_unsolved_question(entry: Dictionary, text: String) -> String:
	var color_1: Color = API.theme.get_color(API.theme.PB)
	var color_3: Color = API.theme.get_color(API.theme.BLACK)
#	print(color_1.to_html())
	var out_entry = "[color=#%s]%s[/color]\n[color=#%s][b]%d letras[/b][/color]\n" % [color_3.to_html(), entry["value"], color_1.to_html(), len(entry["key"])]
	var output = str(text, out_entry)
	return output

func _verify_solution() -> void:
#	print(_solved_itens)
	for i in _numbered_clues:
		var correct = true
		for j in _numbered_clues[i]["buttons"]:
			correct = correct and _button_valid(j)
		if correct:
			_solved_itens[i] = true
			for j in _numbered_clues[i]["buttons"]:
				j["button"].disabled = true
#				if (j["solution"] in _special_char_dicio):
#					j["button"].text = _special_char_dicio[j["solution"]]
				if (j["solution"] in SPECIAL_CHAR_DICIO):
#					print(j["solution"])
#					j["button"].text = SPECIAL_CHAR_DICIO[j["solution"]]
					j["button"].text = j["solution"]

func _verify_endgame() -> void:
	var endgame = true
	for i in _solved_itens:
		endgame = endgame and _solved_itens[i]
	if endgame:
#		$gameOver.show()
		_panel_information.show()
#		print("Jogo terminado")
		emit_signal("game_over")
		var score: int = _score(_run_time)
		_congratulation.bbcode_text = "Você completou o nível! Conseguiu [color=#666666][b]%d[/b][/color] estrelas."%score
		_final_time.text = "%02d:%02d" % [(_run_time/60) % 60, _run_time % 60]
		

func _score(time : int) -> int:
	if time <= SOLVE_TARGET.three:
		return 3
	elif time <= SOLVE_TARGET.two:
		return 2
	elif time <= SOLVE_TARGET.one:
		return 1
	return 0

func _button_valid(button: Dictionary) -> bool:
	if button["solution"] == "" or button["solution"] == " ":
		button["button"].text = ""
		return true
#	if button["solution"] in _special_char_dicio:
	if button["solution"] in SPECIAL_CHAR_DICIO:
#		print(button["solution"])
		var character = button["solution"]
		if character == "" or character == " ":
			button["button"].text = ""
#			return (_special_char_dicio[character] == button["value"])
#			return (SPECIAL_CHAR_DICIO[character] == button["value"])
			return true
		else:
			return (SPECIAL_CHAR_DICIO[character] == button["value"])
#			return false
	else:
		return (button["solution"] == button["value"])
#	return false

func _show_selected_word() -> void:
	for i in _game_buttons:
		if _selected_item in _game_buttons[i]["affiliation"]:
			_game_buttons[i]["button"].pressed = true
		else:
			_game_buttons[i]["button"].pressed = false

func _next_button(button: Dictionary) -> void:
	var direction := Vector2.ZERO
	if (_numbered_clues[_selected_item]["horizontal"]):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.DOWN
	var position = str(button["position"]+direction)
	if (_game_buttons.has(position)):
		var next = _game_buttons[position]
		next["button"].grab_focus()
#		print(next["button"].text)
		if (next["button"].text == ' '):
			_next_button(next)
	
func _previous_button(button: Dictionary) -> void:
	var direction := Vector2.ZERO
	if (_numbered_clues[_selected_item]["horizontal"]):
		direction = Vector2.LEFT
	else:
		direction = Vector2.UP
	var position = str(button["position"]+direction)
	if (_game_buttons.has(position)):
		var prev = _game_buttons[position]
		prev["button"].grab_focus()
#		print(prev["button"].text)
		if (prev["button"].text == ' '):
			_previous_button(prev)

func _show_clue(number: String) -> void:
	_clueNumber.text = number
	_clueNumber.show()
	if (number in _numbered_clues):
#		printt(number, _numbered_clues[number])
		_clue.text = _numbered_clues[number]["clue"]
		_clue.show()
		if _numbered_clues[number]["horizontal"]:
			_orientation.text = "Horizontal"
		else:
			_orientation.text = "Vertical"
		_orientation.show()
		_show_selected_word()
	

func _click_selected(_selected_button: Dictionary) -> void:
#	print(_selected_button["affiliation"])
	var len_affiliation = len(_selected_button["affiliation"])
	if (len_affiliation > 1):
		if (_solved_itens[_selected_button["affiliation"][0]]):
			_selected_item = _selected_button["affiliation"][1]
		elif (_solved_itens[_selected_button["affiliation"][1]]):
			_selected_item = _selected_button["affiliation"][0]
	elif (_selected_item in _selected_button["affiliation"]):
#		var len_affiliation = len(_selected_button["affiliation"])
		if (len_affiliation > 1) and _selected_button["button"].is_hovered():
			# Se eh um segundo click em um botao selecionado
#			printt(_solved_itens, _selected_button["affiliation"])
			if (_selected_button == _last_selected_button):
#				printt(_selected_button, _last_selected_button)
				var position = _selected_button["affiliation"].bsearch(_selected_item)
				_selected_item = _selected_button["affiliation"][posmod(position + 1, len_affiliation)]
	else:
		_selected_item = _selected_button["affiliation"][0]

func _verify_selected(_selected_button: Dictionary) -> void: #verifica qual eh a dica a ser apresentada
	if not _selected_item in _selected_button["affiliation"]:
		_selected_item = _selected_button["affiliation"][0]

func _verify_owner(button: Button) -> Dictionary:
	for i in _game_buttons:
		if _game_buttons[i]["button"] == button:
#			$Keyboard.update_keyset(_game_buttons[i]["keyboard"])
#			_last_selected_button = _game_buttons[i]
			return _game_buttons[i]
	return {}

func _str2vec2(input: String) -> Vector2:
	var output : Vector2 = Vector2.ZERO
	var copy_i : String = input.trim_prefix("(")
	copy_i = copy_i.trim_suffix(")")
	output.x = int(copy_i.split(",")[0])
	output.y = int(copy_i.split(",")[1])
	return output

func _read_data() -> void:
#	var game_data = API.get_game()
	var words = API.get_words()
	var game_table = API.get_word_search()
	
	_sizeX = 0
	_sizeY = 0
	
	for i in game_table:
		var letter: String = game_table[i]
		var button: Button = Button.new()
		var pos   : Vector2 = _str2vec2(i)
		
		button.name = i
		button.text = letter
		button.toggle_mode = true
		
		_game_buttons[i] ={
			"letter": letter,
			"button": button,
			"active": true,
			"position": pos, #importante para encontrar os botoes adjacentes
		}
		
		if pos.x > _sizeX:
			_sizeX = pos.x
		if pos.y > _sizeY:
			_sizeY = pos.y
	
	for i in words:
		_solved_itens[i] = false
		_capital_letters.append(i[0])
	
#	var size := Vector2.ZERO
#	var iteration = 1
#	for i in game_data:
#		var position = game_data[i]["position"] + game_data[i]["direction"]*(len(i))
#		if position.x > size.x:
#			size.x = position.x
#		if position.y > size.y:
#			size.y = position.y
#
#		var label_position = str(game_data[i]["position"] - game_data[i]["direction"])
##		var label_position = str(game_data[i]["position"])
#		var label = Label.new()
#		label.text = str(iteration)
#		label.align = Label.ALIGN_CENTER
#		label.valign = Label.VALIGN_CENTER
#		label.set_v_size_flags(3)
##		print(label_position)
#		_number_labels[label_position] = {"label": label}
#		_numbered_clues[str(iteration)] = {}
#		_numbered_clues[str(iteration)]["clue"] = game_data[i]["clue"]
#		_numbered_clues[str(iteration)]["horizontal"] = game_data[i]["horizontal"]
#		_numbered_clues[str(iteration)]["buttons"] = []
#		for j in range(len(i)):
#			var button_position = str(game_data[i]["position"] + game_data[i]["direction"]*j)
#			if not button_position in _game_buttons:
#				var button = Button.new()
#				button.toggle_mode = true
#				_game_buttons[button_position] = {"solution": i[j],
#												"affiliation": [str(iteration)],
#												"button": button,
#												"solved": false,
#												"position": game_data[i]["position"] + game_data[i]["direction"]*j,
#												"value": "",
#												"keyboard": game_data[i]["keyboard"][j]}
#			else:
#				_game_buttons[button_position]["affiliation"].append(str(iteration))
#
#			#tratar espacos
#			if (i[j] == " "):
##				print("botão vazio")
#				_game_buttons[button_position]["solved"] = true
#				_game_buttons[button_position]["button"].text = " "
#				_game_buttons[button_position]["button"].disabled = true
#
#			_numbered_clues[str(iteration)]["buttons"].append(_game_buttons[button_position])
#		iteration += 1
#
##	print(_numbered_clues)
#
#	_sizeX = size.x
#	_sizeY = size.y
	
func _adjust_size() -> void:
	if _sizeY*RATIO > _sizeX+1:
		_sizeX += 1
		_adjust_size()
	elif _sizeY*RATIO < _sizeX-1:
		_sizeY += 1
		_adjust_size()

func _mount_valid_keys() -> void:
	var file = File.new()
	file.open("res://game/allowed_keys", File.READ) #isso aqui nao vai ser lido
	var f_output = file.get_as_text()
	f_output = f_output.split("\n")
	for i in range(len(f_output)):
		if (i%2 == 1):
			_allowed_keys.append(int(f_output[i]))

func _populate_solved_dict() -> void:
	for i in _numbered_clues:
		_solved_itens[i] = false

func _populate_table() -> void:
#	print()
	_sizeX += 1
	_sizeY += 1
	_gameTable.columns = _sizeX
#	printt(_sizeX, _sizeY, _sizeX*_sizeY)
	for i in range(_sizeY):
		for j in range(_sizeX):
			var newAspect = AspectRatioContainer.new()
			newAspect.set_h_size_flags(3)
			newAspect.set_v_size_flags(3)
			_gameTable.add_child(newAspect)
#			var position = "(%d, %d)"%[j, i]
			var position : String = str(Vector2(j, i))
#			print(position)
			newAspect.add_child(_game_buttons[position]["button"])
#			if (position in _number_labels):
##				print(position)
#				newAspect.add_child(_number_labels[position]["label"])
#			elif (position in _game_buttons):
#				newAspect.add_child(_game_buttons[position]["button"])
#			else:
#				var newPanel = Panel.new()
#				newAspect.add_child(newPanel)

func _mount_special_char() -> void: #O navegador nao vai encontrar esse arquivo
	var glossary = File.new()
	glossary.open("res://game/glossario_acentuacao.json", File.READ)
	var output = JSON.parse(glossary.get_as_text()).result
#	print(output)
	for i in output:
		for j in output[i]:
			_special_char_dicio[j] = i
#	print (_special_char_dicio)

#  [SIGNAL_METHODS]


func _on_Tip_pressed():
	if (_tips > 0):
		if _last_selected_button != null:
#			if not _last_selected_button["solved"]:
			if not _last_selected_button["button"].is_disabled():
				_tips -= 1
				$AspectRatioContainer/Separador/HBoxContainer/AspectRatioContainer2/tipbutton/tips.text = str(_tips)
				_last_selected_button["value"] = _last_selected_button["solution"]
				_last_selected_button["button"].text = _last_selected_button["solution"]
#				_last_selected_button["solved"] = true
				_last_selected_button["button"].set_disabled(true)
				_next_button(_last_selected_button)
				_verify_solution()
				_verify_endgame()
#			print(_selected_button)


func _on_home_pressed():
	API.reset_words()
	get_tree().change_scene("res://intro/intro.tscn")
	
	
func _on_help_pressed():
	$HowToPlay.visible = not $HowToPlay.visible
	$AspectRatioContainer/Separador/Panel.visible = not $AspectRatioContainer/Separador/Panel.visible


func _on_Timer_timeout():
	_run_time += 1
	_timer_display.text = "%02d:%02d" % [(_run_time/60) % 60, _run_time % 60]


func _mouse_hovered():
	print("entrou")


func _on_show_result_pressed():
	_panel_information.show()
	_show_result_button.hide()


func _on_hide_result_pressed():
	_panel_information.hide()
	_show_result_button.show()

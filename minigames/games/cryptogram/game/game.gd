extends Control


#  [DOCSTRING]


#  [SIGNALS]
signal game_over
signal table_change
signal table_filled
signal table_reset_color

#  [ENUMS]
enum SOLVE_TARGET {
	three = 90,
	two = 150,
	one = 240,
}

#  [CONSTANTS]
const scene_entry = preload("res://entry/entry.tscn")
const scene_letter = preload("res://entry/letter.tscn")

const ALLOWED_KEYS = [81, 87, 69, 82, 84, 89, 85, 73, 79, 80, 65, 83, 68, 70, 71, 72, 74, 75, 76, 90, 88, 67, 86, 66, 78, 77, 59, 16777220]
const SPECIAL_CHAR_DICIO = {'Á': 'A', 'À': 'A', 'Ã': 'A', 'Â': 'A', 'É': 'E', 'È': 'E', 'Ẽ': 'E', 'Ê': 'E', 'Í': 'I', 'Ì': 'I', 'Ĩ': 'I', 'Î': 'I', 'Ó': 'O', 'Ò': 'O', 'Õ': 'O', 'Ô': 'O', 'Ú': 'U', 'Ù': 'U', 'Ũ': 'U', 'Û': 'U', 'Ç': 'C', 'Ñ': 'N', '': ' ', ' ': ' '}
const LETTER_CODE := {'Q': 81, 'W': 87, 'E': 69, 'R': 82, 'T': 84, 'Y': 89, 'U': 85, 'I': 73, 'O': 79, 'P': 80, 'A': 65, 'S': 83, 'D': 68, 'F': 70, 'G': 71, 'H': 72, 'J': 74, 'K': 75, 'L': 76, 'Z': 90, 'X': 88, 'C': 67, 'V': 86, 'B': 66, 'N': 78, 'M': 77, 'ç': 59, 'backspace': 16777220}
const SYMBOL_LIST = ['\uf51c', # nf-mdi-airplane
					'\uf51f', # nf-mdi-alarm
					'\uf75c', # nf-mdi-football
					'\uf565', # nf-mdi-attachment
					'\uf290', # nf-fa-shopping_bag
					'\uf51b', # nf-mdi-airballoon
					'\uf575', # nf-mdi-basket
					'\ufd04', # nf-mdi-basketball
					'\uf499', # nf-oct-beaker
					'\uf0fc', # nf-fa-beer
					'\uf206', # nf-fa-bicycle
					'\uf06d', # nf-fa-fire
					'\uf02d', # nf-fa-book
#					'\ueaaf', # nf-cod-bug
					'\uf0eb', # nf-fa-lightbulb_o
					'\uf5e6', # nf-mdi-bus
					'\uf0f4', # nf-fa-coffee
					'\uf1ec', # nf-fa-calculator
#					'\ueb92', # nf-cod-call_incoming
					'\uf030', # nf-fa-camera
					'\uf60a', # nf-mdi-car
					'\uf60f', # nf-mdi-cart
					'\ue22b', # nf-fae-palette_color
					'\uf1b2', # nf-fa-cube
					'\uf68f', # nf-mdi-content_cut
					'\uf219', # nf-fa-diamond
					'\uf759', # nf-mdi-food
					'\uf739', # nf-mdi-fish
					'\uf490', # nf-oct-flame
					'\ue241', # nf-fae-footprint
					'\uf7a0', # nf-mdi-gift
					'\uf7cd', # nf-mdi-headset
					'\ufd28', # nf-mdi-ice_cream
					'\uf80a', # nf-mdi-key_variant
					'\uf829', # nf-mdi-leaf
					'\uf45f', # nf-oct-megaphone
					'\uf75a', # nf-mdi-food_apple
					'\ue30c', # nf-weather-day_sunny_overcast
					'\uf1b0', # nf-fa-paw
#					'\ue684', # nf-seti-prisma
					'\ue239', # nf-fae-raining
					'\uf95f', # nf-mdi-ribbon
					'\uf962', # nf-mdi-rocket
					'\ufb8a', # nf-mdi-skull
					'\ue209', # nf-fae-telescope
					'\ue220', # nf-fae-umbrella
					'\uf091', # nf-fa-trophy
					'\ufa8b', # nf-mdi-water
					]


#  [EXPORTED_VARIABLES]

#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _selected: String

#  [ONREADY_VARIABLES]

onready var _table: VBoxContainer = $AspectRatioContainer/Separador/Panel/GameTable
onready var _panel_info: Panel = $PanelInformation
#onready var _back_panel: Panel = $AspectRatioContainer/Separador/Panel
onready var _solution_letters: Dictionary = {}
onready var _solution_mask: Dictionary = {}
onready var _reverse_solution: Dictionary = {}
onready var _user_solution: Dictionary = {}
onready var _game_running: bool = true
onready var _timer: Timer = $Timer
onready var _timer_display: Label = $AspectRatioContainer/Separador/HBoxContainer/timer
onready var _run_time: int = 0
onready var _congratulation: RichTextLabel = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/CongratulationsContainer/TotalStars
onready var _final_time: Label = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/StatisticsContainer/TimeContainer/TotalTime
onready var _left_tips: int = 10
onready var _tip_display: Label = $AspectRatioContainer/Separador/HBoxContainer/AspectRatioContainer2/ThemeButtonIcon/tips
onready var _reset_color: int = -1

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass

func _ready():
	_gen_solution_table()
	_populate_table()
	print(API.get_game_words())
	if OS.has_virtual_keyboard():
		$HidedText.text = "Há suporte"
#		OS.show_virtual_keyboard()
#	_timer.start()
	
#	print(_solution_mask)
#  [BUILT-IN_VIRTUAL_METHOD]

func _unhandled_key_input(event):
#	print(event)
#	if event is InputEventKey:
#		print(event.is_pressed())
		
	if event is InputEventKey and event.is_pressed():
		var event_key = event as InputEventKey
#		var dic_button = _verify_owner(self.get_focus_owner()) as Dictionary
#		_last_selected_button = dic_button
#		if ((event_key.get_physical_scancode() in _allowed_keys) and dic_button.has("button")):
#		if ((event_key.get_physical_scancode() in ALLOWED_KEYS) and dic_button.has("button")):
		if ((event_key.get_physical_scancode() in ALLOWED_KEYS) and _game_running) :
			_user_solution[_selected] = char(event_key.get_scancode())
			_update_user_solution()
			_table_full()
			_verify_solution()
			var next:Control = self.get_focus_owner().find_next_valid_focus()
			next.grab_focus()
#			if not dic_button["button"].disabled:
#				dic_button["value"] = char(event_key.get_scancode())
#				dic_button["button"].text = char(event_key.get_scancode())
#			if (event_key.get_physical_scancode() == 16777220): #Backspace
#				_previous_button(dic_button)
#			else:
#				_next_button(dic_button)
#			_show_selected_word()
#			_verify_solution()
#			_verify_endgame()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
##	_timer_display.text = 
#	print(_timer.wait_time)
#	print(_timer.time_left)
#	print(_timer.is_stopped())


#  [PUBLIC_METHODS]

func get_new_solution(valor: String) -> String:
	return _user_solution[valor]

func set_selected_symbol(valor: String) -> void:
	_selected = valor

func get_correct_letter(valor: String) -> String:
	for i in _solution_letters:
		if (_solution_letters[i] == valor):
			return i
	return "-1"
#  [PRIVATE_METHODS]

func _score(time : int) -> int:
	if time <= SOLVE_TARGET.three:
		return 3
	elif time <= SOLVE_TARGET.two:
		return 2
	elif time <= SOLVE_TARGET.one:
		return 1
	return 0

func _gen_solution_table() -> void:
	seed(ceil(Time.get_unix_time_from_system()))
	var valid : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#	print(len(SYMBOL_LIST))
	var copylist: Array = SYMBOL_LIST.duplicate(true)#.slice(47 - valid.length(), 47)
	for i in valid:
		copylist.shuffle()
		var symbol: String = copylist.pop_front()
#		_solution_letters[symbol] = i
		_solution_letters[i] = symbol
#		_solution_mask[i] = false
		_solution_mask[i] = true
		_user_solution[symbol] = ""

func _populate_table() -> void:
	for i in API.get_game_words():
#		print(i.to_upper())
		var i_entry : Panel = scene_entry.instance()
		var i_box : HBoxContainer = i_entry.get_node("Entry")
#		print(i_entry)
		var i_up : String = i.to_upper()
#		var i_tip : Label = i_entry.get_node("Tip")
#		var i_tip : RichTextLabel = i_entry.get_node("Entry/Tip")
		var i_tip : RichTextLabel = i_entry.get_node("Entry/Tip")
#		var i_text: String = API.get_game_words()[i]
#		print(API.get_game_words())
#		print(i_tip)
#		i_tip.text = API.get_game_words()[i]["clue"]
		var large_clue = _extra_espace(API.get_game_words()[i]["clue"])
		i_tip.text = large_clue
#		i_tip.text = i
#		i_tip.text = "i_text"
#		print(API.get_game_words()[i])
		_table.add_child(i_entry)
		for j in i_up:
			var j_letter = scene_letter.instance()
			var j_pic : Label = j_letter.get_node("letter/pic")
			var j_sol : Button = j_letter.get_node("letter/letter")
			var je : String = j
			if je in SPECIAL_CHAR_DICIO:
				je = SPECIAL_CHAR_DICIO[j]
			if je in _solution_letters:
				j_pic.text = _solution_letters[je]
				_solution_mask[je] = false
#				_solution_mask[je] = true
				self.connect("table_change", j_letter, "_on_solution_changed")
			else:
				j_pic.text = " "
				j_sol.disabled = true
			i_box.add_child(j_letter)
			

func _extra_espace(text: String) -> String:
	if (len(text) > 50):
		return text
#		return "\n" + text
	else:
		return "\n"+ text
#		return "\n\n"+ text
#	return ""

func _get_actual_symbol() -> void:
	pass

func _update_user_solution () -> void:
	emit_signal("table_change")

func _table_full() -> void:
	var filled: bool = true
	for i in _solution_mask:
		var simb = _solution_letters[i]
		if (not _solution_mask[i]):
#			print(_user_solution[simb])
			if (_user_solution[simb] == ""):
				filled = false
	if (filled):
#		print("tabela cheia")
		emit_signal("table_filled")
		if (_reset_color <= 0):
			_reset_color = 5

func _verify_solution () -> void:
#	print()
	var win_rule = true
#	printt(_solution_mask, _user_solution)
	for i in _solution_mask: # "i" eh a letra a ser testada
		var mask = _solution_mask[i] # se isso aqui eh verdadeiro, a rodada eh verdadeira
		var simb = _solution_letters[i] # simbolo correto para a letra i
		var comp = i == _user_solution[simb] # verifica se o valor atribuido pelo usuario eh igual a resposta
		win_rule = win_rule and (mask or comp)
#		printt(mask, i, _user_solution[simb], (mask or comp))
#		var round_iteration = true
#		if (_solution_mask[i]):
#			for j in _user_solution:
#				if (i == _user_solution[j]):
#					round_iteration = true
#		else:
#			round_iteration = true
#		win_rule = win_rule and round_iteration
##		printt(i, win_rule)
	if (win_rule):
		print("fim de jogo")
		_panel_info.show()
		_game_running = false
		emit_signal("game_over")
		var score: int = _score(_run_time)
		_congratulation.bbcode_text = "Você completou o nível! Conseguiu [color=#666666][b]%d[/b][/color] estrelas."%score
		_final_time.text = "%02d:%02d" % [(_run_time/60) % 60, _run_time % 60]

func _simb_solution(simbol:String) -> String:
	for i in _solution_letters:
		if (_solution_letters[i] == simbol):
			return i
	return simbol

#  [SIGNAL_METHODS]


func _on_home_pressed():
	get_tree().change_scene("res://home/home.tscn")


func _on_Timer_timeout():
	_run_time += 1
	_timer_display.text = "%02d:%02d" % [(_run_time/60) % 60, _run_time % 60]
	
	_reset_color -= 1
	if (_reset_color == 0):
		emit_signal("table_reset_color")


func _on_tip_pressed():
	var selected: Control = self.get_focus_owner().get_parent().find_node("pic")
	var simbol: String = selected.text
	var solution: String = _simb_solution(simbol)
	if (simbol != solution):
		if (_left_tips > 0):
			_left_tips -= 1
			_tip_display.text = str(_left_tips)
			var new_event: InputEventKey = InputEventKey.new()
			new_event.set_pressed(true)
			new_event.set_physical_scancode(LETTER_CODE[solution])
			new_event.set_scancode(LETTER_CODE[solution])
			get_tree().input_event(new_event)
			var flush_event = InputEventKey.new()
			get_tree().input_event(flush_event)
			

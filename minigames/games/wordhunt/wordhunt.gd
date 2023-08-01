extends Control


signal end_game


const _GameResults: PackedScene = preload("res://game_results/game_results.tscn")
const _HowToPlay: PackedScene = preload("res://how_to_play/how_to_play.tscn")
const _HowToPlayTextures: Array = Array([
#	preload("res://assets/images/htp_puzzle_game_0.png"),
])


var _timer_has_started: bool = false \
		setget set_timer_has_starded, get_timer_has_started

var _timer_counter: int = 0 \
		setget set_timer_counter, get_timer_counter

var _failed_attempt: int = 0 \
		setget set_failed_attempt, get_failed_attempt


onready var _grid: GridContainer = $"%GridLabelContainer"
onready var _tips: ScrollContainer = $"%TipListContainer"
onready var _selected_word: Label = $"%SelectedWord"
onready var _line_marker: CanvasLayer = $"%LineMarker"
onready var _timer: Timer = $"%Timer"
onready var _timer_label: Label = $"%Time"
onready var _floating_screen_layer: CanvasLayer = $"%FloatingScreenLayer"


func _ready() -> void:
	_selected_word.set_text("")
	set_timer_has_starded(true)

	connect("end_game", self, "_on_self_end_game")

	_grid.connect("selected_word", self, "_on_self_selected_word")
	_grid.connect("first_letter_selected", self, "_on_grid_first_letter_selected")
	_grid.connect("last_letter_selected", self, "_on_grid_last_letter_selected")
	_grid.connect("selection_finish", self, "_on_selection_finish")


func set_timer_has_starded(new_value: bool) -> void:
	_timer_has_started = new_value
	_timer.start()


func get_timer_has_started() -> bool:
	return _timer_has_started


func set_timer_counter(new_value: int) -> void:
	_timer_counter = new_value


func get_timer_counter() -> int:
	return _timer_counter


func set_failed_attempt(new_value: int) -> void:
	_failed_attempt = new_value


func get_failed_attempt() -> int:
	return _failed_attempt


func has_game_finished() -> void:
	var game_finish: bool = false

	for tip in _tips.get_list().get_children():
		if tip.get_state() == tip.State.NOT_SOLVED:
			game_finish = false
			break
		else:
			game_finish = true

	if game_finish:
		emit_signal("end_game")


func scoring_rules() -> int:
	var target_attempt: int = 0
	var margin_attempt: int = 0
	var target_time: int = 0
	var margin_time: int = 0
	var stars: int = 0
	var stars_check: bool = false

	# define difficulty parameters
	target_attempt = 30
	margin_attempt = 6
	target_time = 120
	margin_time = 30

	# three stars
	if get_timer_counter() < target_time and get_failed_attempt() < target_attempt:
		if not stars_check:
			stars = 3
			stars_check = true

	# two stars
	elif get_timer_counter() < (target_time + margin_time) and get_failed_attempt() < (target_attempt + margin_attempt):
		if not stars_check:
			stars = 2
			stars_check = true

	# one stars
	elif (get_timer_counter() < (target_time + margin_time) and get_failed_attempt() > (target_attempt + margin_attempt)) or \
			(get_timer_counter() > (target_time + margin_time) and get_failed_attempt() < (target_attempt + margin_attempt)):
		if not stars_check:
			stars = 1
			stars_check = true

	# zero stars
	elif get_timer_counter() > (target_time + margin_time) and get_failed_attempt() > (target_attempt + margin_attempt):
		if not stars_check:
			stars = 0
			stars_check = true

	return stars


func _on_self_selected_word(word: String) -> void:
	_selected_word.set_text(word)


func _on_grid_first_letter_selected(letter: GridLabelItem) -> void:
	_line_marker.add_first_point(letter)


func _on_grid_last_letter_selected(letter: GridLabelItem) -> void:
	_line_marker.add_last_point(letter)


func _on_selection_finish(first_letter: GridLabelItem, last_letter: GridLabelItem, word: String) -> void:
	var word_found: bool = false
	for tip in _tips.get_list().get_children():
		if tip.get_state() == tip.State.NOT_SOLVED:
			if word == tip.get_expected_word():
				word_found = true
				tip.define_tip_solved()


	if word_found == true:
		_line_marker.add_permanent_line(first_letter, last_letter)
		has_game_finished()

	else:
		set_failed_attempt(get_failed_attempt() + 1)
		print(get_failed_attempt())


func _on_timer_timeout() -> void:
	var seconds: int = get_timer_counter()
	seconds += 1
	set_timer_counter(seconds)

# warning-ignore:integer_division
	_timer_label.text = "%02d:%02d" % [(seconds/60) % 60, seconds % 60]


func _on_self_end_game() -> void:
	_timer.stop()

	var game_results_instance: Panel = _GameResults.instance()
	_floating_screen_layer.add_child(game_results_instance)

	game_results_instance.hide_panel.visible = true

	var message_game: String = String((
		"Você completou o quebra cabeças."
	))

	var message_statistic: String = String((
		"Tempo: [color=#{color}][b]{time}[/b][/color]" +
		"\nTentativas: [color=#{color}][b]{attempt}[/b][/color]"
	).format({
		"color": API.theme.get_color(API.theme.PB).to_html(false),
		"time": _timer_label.text,
		"attempt": "%02d" % get_failed_attempt()
	}))

	game_results_instance.update_data(message_game, message_statistic, scoring_rules())
	game_results_instance.connect("restart_level", self, "_on_game_results_restart_level")
	game_results_instance.connect("continue_level", self, "_on_game_results_continue_level")


func _on_game_results_restart_level() -> void:
	get_tree().change_scene("res://games/wordhunt/wordhunt.tscn")


func _on_game_results_continue_level() -> void:
	get_tree().change_scene("res://home/home.tscn")


func _on_home_pressed() -> void:
	get_tree().change_scene("res://home/home.tscn")


func _on_help_pressed() -> void:
	_timer.stop()

	var how_to_play_instance := _HowToPlay.instance()
	_floating_screen_layer.add_child(how_to_play_instance)
	how_to_play_instance.set_textures(_HowToPlayTextures)
	how_to_play_instance.connect("closed", self, "_on_HowToPlay_closed")


func _on_HowToPlay_closed() -> void:
	if get_timer_counter() > 0:
		_timer.start()

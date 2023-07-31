extends Control


signal end_game

var _timer_has_started: bool = false \
		setget set_timer_has_starded, get_timer_has_started

var _timer_counter: int = 0 \
		setget set_timer_counter, get_timer_counter

onready var _grid: GridContainer = $"%GridLabelContainer"
onready var _tips: ScrollContainer = $"%TipListContainer"
onready var _selected_word: Label = $"%SelectedWord"
onready var _line_marker: CanvasLayer = $"%LineMarker"
onready var _timer: Timer = $"%Timer"
onready var _timer_label: Label = $"%Time"


func _ready() -> void:
	_selected_word.set_text("")
	set_timer_has_starded(true)

	connect("end_game", self, "_on_self_end_game")

	_grid.connect("selected_word", self, "_on_self_selected_word")
	_grid.connect("first_letter_selected", self, "_on_grid_first_letter_selected")
func set_timer_has_starded(new_value: bool) -> void:
	_timer_has_started = new_value
	_timer.start()


func get_timer_has_started() -> bool:
	return _timer_has_started


func set_timer_counter(new_value: int) -> void:
	_timer_counter = new_value


func get_timer_counter() -> int:
	return _timer_counter



func _on_self_selected_word(word: String) -> void:
	_selected_word.set_text(word)


func _on_grid_first_letter_selected(letter: GridLabelItem) -> void:
	_line_marker.add_first_point(letter)


func _on_grid_end_letter_selected(letter: GridLabelItem) -> void:
	_line_marker.add_last_point(letter)
func _on_self_end_game() -> void:
	_timer.stop()

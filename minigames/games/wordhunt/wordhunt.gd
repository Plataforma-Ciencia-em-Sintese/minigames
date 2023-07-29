extends Control


onready var _grid: GridContainer = $"%GridLabelContainer"
onready var _tips: ScrollContainer = $"%TipListContainer"
onready var _selected_word: Label = $"%SelectedWord"
onready var _line_marker: CanvasLayer = $"%LineMarker"


func _ready() -> void:
	_selected_word.set_text("")

	_grid.connect("selected_word", self, "_on_self_selected_word")
	_grid.connect("first_letter_selected", self, "_on_grid_first_letter_selected")
	_grid.connect("end_letter_selected", self, "_on_grid_end_letter_selected")


func _on_self_selected_word(word: String) -> void:
	_selected_word.set_text(word)


func _on_grid_first_letter_selected(letter: GridLabelItem) -> void:
	_line_marker.add_first_point(letter)


func _on_grid_end_letter_selected(letter: GridLabelItem) -> void:
	_line_marker.add_last_point(letter)

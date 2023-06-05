#tool
#class_name API #, res://class_name_icon.svg
extends Node


#  [DOCSTRING]


#  [SIGNALS]
signal all_request_completed
signal a_request_completed
signal request_game_completed
signal all_request_failed


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]
var common: RequestCommon
var game: RequestGame
var theme: RequestTheme
var process_data: ProcessData


#  [PRIVATE_VARIABLES]
var _is_common_completed: bool = false \
		setget set_is_common_completed, get_is_common_completed

var _is_game_completed: bool = false \
		setget set_is_game_completed, get_is_game_completed

var _is_theme_completed: bool = false \
		setget set_is_theme_completed, get_is_theme_completed

var _is_request_error: bool = false \
		setget set_is_request_error, get_is_request_error


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
func _init() -> void:
	common = RequestCommonOmeka.new()
	game = RequestGameOmeka.new()
	theme = RequestThemeOmeka.new()
	process_data = ProcessData.new()


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	connect("a_request_completed", self, "_on_a_request_completed")
	
	add_child(common)
	common.connect("all_request_common_completed", self, "_on_all_request_common_completed")
	common.connect("request_error", self, "_on_request_error")
	
#	set_is_game_completed(true)
	add_child(game)
	game.connect("all_request_game_completed", self, "_on_all_request_game_completed")
	game.connect("request_error", self, "_on_request_error")
	
#	print(process_data)
	add_child(process_data)
	_load_game_data(process_data, game)
	
#	set_is_theme_completed(true)
	add_child(theme)
	theme.connect("all_request_theme_completed", self, "_on_all_request_theme_completed")
	theme.connect("request_error", self, "_on_request_error")
#	print(common.get_resources())
#	ProcessData.set_game_contains(common.get_resources()["game:contains"])
#	ProcessData.start_process()
#	yield(self, "request_game_completed")
	


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_is_common_completed(new_value: bool) -> void:
	_is_common_completed = new_value


func get_is_common_completed() -> bool:
	return _is_common_completed


func set_is_game_completed(new_value: bool) -> void:
	_is_game_completed = new_value


func get_is_game_completed() -> bool:
	return _is_game_completed


func set_is_theme_completed(new_value: bool) -> void:
	_is_theme_completed = new_value


func get_is_theme_completed() -> bool:
	return _is_theme_completed


func set_is_request_error(new_value: bool) -> void:
	_is_request_error = new_value


func get_is_request_error() -> bool:
	return _is_request_error


func is_all_request_completed() -> bool:
	if get_is_common_completed():
		if get_is_game_completed():
			if get_is_theme_completed():
				return true

	return false

func get_game() -> Dictionary:
	return process_data.get_game()

func get_word_search() -> Dictionary:
	return process_data.get_word_search()

func get_words() -> Dictionary:
	return process_data.get_words()

func get_keyset() -> Array:
	return process_data.get_keyset()

func reset_words() -> void:
	process_data.reset()
	process_data.set_words(game.get_words())

#  [PRIVATE_METHODS]
 
func _load_game_data(processor_node:Node, gamenode:Node) -> void:
	yield(self, "request_game_completed")
#	print(processor_node)
#	print(processor_node.SPECIAL_CHAR_DICIO)
	processor_node.set_words(gamenode.get_words())

#  [SIGNAL_METHODS]
func _on_all_request_common_completed() -> void:
	print("_on_all_request_common_completed()")
	set_is_common_completed(true)
	emit_signal("a_request_completed")


func _on_all_request_game_completed() -> void:
	print("_on_all_request_game_completed()")
	set_is_game_completed(true)
	emit_signal("a_request_completed")
	emit_signal("request_game_completed")
	
#	var scroll := ScrollContainer.new()
#	add_child(scroll)
#	scroll.anchor_bottom = 1.0
#	scroll.anchor_right = 1.0
#
#	var grid := GridContainer.new()
#	scroll.add_child(grid)
#
#	for card in game.get_cards():
#		var texture_rect := TextureRect.new()
#		grid.add_child(texture_rect)
#		texture_rect.texture = card["image"]
#
#		var label := Label.new()
#		texture_rect.add_child(label)
#		label.text = card["subtitle"]


func _on_all_request_theme_completed() -> void:
	print("_on_all_request_theme_completed()")
	set_is_theme_completed(true)
	emit_signal("a_request_completed")
	
#	prints("\nPrimary color:", theme.get_primary_color().to_html(false))
#	prints("PB:", theme.get_color(theme.PB).to_html(false))
#	prints("PL1:", theme.get_color(theme.PL1).to_html(false))
#	prints("PL2:", theme.get_color(theme.PL2).to_html(false))
#	prints("PL3:", theme.get_color(theme.PL3).to_html(false))
#	prints("PD1:", theme.get_color(theme.PD1).to_html(false))
#	prints("PD2:", theme.get_color(theme.PD2).to_html(false))
#	prints("PD3:", theme.get_color(theme.PD3).to_html(false))
#
#	prints("\nSecondary color:", theme.get_secondary_color().to_html(false))
#	prints("SB:", theme.get_color(theme.SB).to_html(false))
#	prints("SL1:", theme.get_color(theme.SL1).to_html(false))
#	prints("SL2:", theme.get_color(theme.SL2).to_html(false))
#	prints("SL3:", theme.get_color(theme.SL3).to_html(false))
#	prints("SD1:", theme.get_color(theme.SD1).to_html(false))
#	prints("SD2:", theme.get_color(theme.SD2).to_html(false))
#	prints("SD3:", theme.get_color(theme.SD3).to_html(false))
#
#	var texture_rect: TextureRect = TextureRect.new()
#	add_child(texture_rect)
#	texture_rect.expand = true
#	texture_rect.stretch_mode = TextureRect.STRETCH_TILE
#	texture_rect.anchor_bottom = 1.0
#	texture_rect.anchor_right = 1.0
#	texture_rect.texture = theme.get_background_texture()


func _on_a_request_completed() -> void:
	#prints(get_is_common_completed(), get_is_game_completed(), get_is_theme_completed())
	if is_all_request_completed():
		emit_signal("all_request_completed")


func _on_request_error(request_failed: String) -> void:
	if not get_is_request_error():
		set_is_request_error(true)
		emit_signal("all_request_failed")
	
	push_error(request_failed)

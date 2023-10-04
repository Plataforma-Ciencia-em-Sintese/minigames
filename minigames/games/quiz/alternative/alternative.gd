#tool
class_name Alternative #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]
signal pressed(message)


#  [ENUMS]


#  [CONSTANTS]
var CHECKER_TEXTURE_INCORRECT: StreamTexture = preload("res://assets/images/incorrect.png")
var CHECKER_TEXTURE_CORRECT: StreamTexture = preload("res://assets/images/correct.png")


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _checker_state: bool = false \
		setget set_checker_state, get_checker_state


#  [ONREADY_VARIABLES]
onready var checker: TextureRect = $HBoxContainer/Checker
onready var panel: Panel = $HBoxContainer/Panel
onready var number: Label = $HBoxContainer/Panel/MarginContainer/HBoxContainer/Number
onready var message: Label = $HBoxContainer/Panel/MarginContainer/HBoxContainer/Message


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_checker_state(new_value: bool) -> void:
	_checker_state = new_value
	match(new_value):
		true:
			checker.texture = CHECKER_TEXTURE_CORRECT

		false:
			checker.texture = CHECKER_TEXTURE_INCORRECT

		_:
			pass


func get_checker_state() -> bool:
	return _checker_state


func disabled(value: bool, visibility: bool = false) -> void:
	match(value):
		true:
			if visibility:
				panel.set("modulate", Color(1.0, 1.0, 1.0, 1.0))
			else:
				panel.set("modulate", Color(1.0, 1.0, 1.0, 0.5))
			panel.get_node("TextureButton").disabled = true

		false:
			panel.set("modulate", Color(1.0, 1.0, 1.0, 1.0))
			panel.get_node("TextureButton").disabled = false

		_:
			pass


func is_disabled() -> bool:
	return panel.get_node("TextureButton").disabled


func checker_visible(value: bool) -> void:
	match(value):
		true:
			checker.set("modulate", Color(1.0, 1.0, 1.0, 1.0))

		false:
			checker.set("modulate", Color(1.0, 1.0, 1.0, 0.0))

		_:
			pass


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	var number_style: StyleBoxFlat = number.get("custom_styles/normal")
	number_style.set("bg_color", API.theme.get_color(API.theme.SB))

	var panel_style: StyleBoxFlat = panel.get("custom_styles/panel")
	panel_style.set("bg_color", API.theme.get_color(API.theme.PB))


#  [SIGNAL_METHODS]
func _on_TextureButton_pressed() -> void:
	emit_signal("pressed", str(message.text))

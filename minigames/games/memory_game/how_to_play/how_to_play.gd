#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]

signal close


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]
onready var label: Label = $MarginContainer/VBoxContainer/Panel/Label


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


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	label.set("custom_colors/font_color", API.theme.get_color(API.theme.PD1))
	var state_normal: StyleBoxFlat = label.get("custom_styles/normal")
	state_normal.set("border_color", API.theme.get_color(API.theme.PD1))
 

#  [SIGNAL_METHODS]


func _on_Button_pressed() -> void:
	emit_signal("close")
	queue_free()

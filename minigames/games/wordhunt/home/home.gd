#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	var title = $title
	title.set_text(API.common.get_short_title())
	_update_theme()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _update_theme() -> void:
	var default = self.get_theme()
	var box
	
	box = default.get_stylebox("normal", "Label")
	box.border_color = API.theme.get_color(API.theme.PD2)
	default.set_color("font_color", "Label", API.theme.get_color(API.theme.PB))
#	box.border_color = API.theme.get_color(API.theme.PB)
	
#	box = $container/circle.get_stylebox("custom_styles/panel", "override")
	box = $container/circle.get("custom_styles/panel")
	box.bg_color = API.theme.get_color(API.theme.PB)
#	print(box)
 

#  [SIGNAL_METHODS]


#func _on_Easy_pressed() -> void:
#	ChangeLevel.request_mode = ChangeLevel.GameMode.EASY
#	get_tree().change_scene("res://game/game.tscn")
#
#
#func _on_Medium_pressed() -> void:
#	ChangeLevel.request_mode = ChangeLevel.GameMode.MEDIUM
#	get_tree().change_scene("res://game/game.tscn")
#
#
#func _on_Hard_pressed() -> void:
#	ChangeLevel.request_mode = ChangeLevel.GameMode.HARD
#	get_tree().change_scene("res://game/game.tscn")


#func _on_next_button_up():
##	print("vish")
#	get_tree().change_scene("res://intro/intro.tscn")


func _on_play_pressed():
	get_tree().change_scene("res://game/game.tscn")



func _on_credit_pressed():
	get_tree().change_scene("res://credits/credits.tscn")

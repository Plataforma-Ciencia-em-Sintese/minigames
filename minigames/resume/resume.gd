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
onready var article_summary: Label = $MarginContainer/Panel/VBoxContainer/HBoxContainer2/Panel/MarginContainer/VBoxContainer/Text
onready var redirect: Button = $MarginContainer/Panel/VBoxContainer/HBoxContainer2/Panel/MarginContainer/VBoxContainer/Redirect
onready var pet: TextureRect = $MarginContainer/Panel/VBoxContainer/HBoxContainer2/AspectRatioContainer/TextureRect

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()
	
	pet.texture = API.common.get_pet()
	
	article_summary.text = API.common.get_article_summary() #+ "\n\n Bom Divertimento!"
	
	if API.common.get_article_link() == "":
		redirect.disabled = true
		redirect.set("modulate", Color(1.0, 1.0, 1.0, 0.0))


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	article_summary.set("custom_colors/font_color", API.theme.get_color(API.theme.PD2))
 

#  [SIGNAL_METHODS]
func _on_Redirect_pressed() -> void:
	var url: String = API.common.get_article_link()
	OS.shell_open(url)


func _on_Skip_pressed() -> void:
	get_tree().change_scene("res://home/home.tscn")


func _on_Credits_pressed() -> void:
	get_tree().change_scene("res://credits/credits.tscn")

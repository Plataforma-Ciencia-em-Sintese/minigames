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
onready var label: Label = $MarginContainer/VBoxContainer/Panel/Label
onready var content: Label = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/Content
onready var team: RichTextLabel = $MarginContainer/VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/Team

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()

	if API.common.get_content_credits() != "":
		content.text = API.common.get_content_credits()

	_checks_contributors()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	label.set("custom_colors/font_color", API.theme.get_color(API.theme.PD1))
	var state_normal: StyleBoxFlat = label.get("custom_styles/normal")
	state_normal.set("border_color", API.theme.get_color(API.theme.PD1))


func _checks_contributors() -> void:
	if API.common.get_resource_id() == API.ResourceID.CRYPTOGRAM:
		team.bbcode_text = """
[center]
[b]Development[/b]
Cairé Carneiro Rocha
Rafael Sescato de Oliveira

[b]Game Design[/b]
Guilherme André Guimarães Santos
Melina Juraski Pereira da Silva

[b]UI/UX[/b]
Elízeo Miguel Hamu Dias
Yoga Rodrigues Alves Viana Neves
Viviane Gomes de Alvarenga

[b]Comunicação[/b]
Tuanny Carvalho

[b]Coordenação[/b]
Ronnie Fagundes de Brito
[/center]
"""


#  [SIGNAL_METHODS]
func _on_Button_pressed() -> void:
	get_tree().change_scene("res://home/home.tscn")

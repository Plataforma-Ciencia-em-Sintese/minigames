#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]
export var background_color: bool = true
export var background_texture: bool = true


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]
onready var color_rect: ColorRect = $"ColorRect"
onready var texture_rect: TextureRect = $"TextureRect"


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	if get_name() == get_tree().get_current_scene().get_name():
		pass

	else:
		_change_background_color(API.theme.get_color(API.theme.PB))
		_change_background_texture(API.theme.get_background_texture())
		


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _change_background_color(color: Color) -> void:
	if background_color:
		color_rect.color = color
	else:
		color_rect.visible = false


func _change_background_texture(texture: ImageTexture) -> void:
	if background_texture:
		texture_rect.texture = texture
		texture_rect.set("modulate", API.theme.get_color(API.theme.PD1))
	else:
		texture_rect.visible = false


#  [SIGNAL_METHODS]

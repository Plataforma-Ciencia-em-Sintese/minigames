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
	if background_color:
		color_rect.color = API.theme.get_color(API.theme.PB)
	else:
		color_rect.visible = false
		
	if background_texture:
		texture_rect.texture = API.theme.get_background_texture()
		texture_rect.set("modulate", API.theme.get_color(API.theme.PD1))
	else:
		texture_rect.visible = false


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

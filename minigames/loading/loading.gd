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
onready var panel_error: PanelContainer = $PanelError
onready var animated_logo: AnimatedSprite = $CanvasLayer/AnimatedSprite


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	panel_error.visible = false
	animated_logo.position = get_viewport_rect().size / 2
	get_viewport().connect("size_changed", self, "_on_size_changed")


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func show_error() -> void:
	panel_error.visible = true


#  [PRIVATE_METHODS]

 
#  [SIGNAL_METHODS]
func _on_size_changed() -> void:
	animated_logo.position = get_viewport_rect().size / 2

#tool
#class_name Name #, res://class_name_icon.svg
extends Button


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]
enum ColorOptions {PRIMARY, SECUNDARY}


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]
export(ColorOptions) var selected_color: int = ColorOptions.PRIMARY


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	match(selected_color):
		ColorOptions.PRIMARY:
			set_primary_color()
		ColorOptions.SECUNDARY:
			set_secondary_color()
		_:
			set_primary_color()
	


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_primary_color() -> void:
	self.set("custom_colors/font_color", API.theme.get_color(API.theme.WHITE))
	self.set("custom_colors/font_color_hover", API.theme.get_color(API.theme.WHITE))
	self.set("custom_colors/font_color_pressed", API.theme.get_color(API.theme.PB))
	
	var state_hover: StyleBoxFlat = self.get("custom_styles/hover")
	state_hover.set("bg_color", API.theme.get_color(API.theme.PL1))
	state_hover.set("border_color", API.theme.get_color(API.theme.PD2))
	
	var state_pressed: StyleBoxFlat = self.get("custom_styles/pressed")
	state_pressed.set("bg_color", API.theme.get_color(API.theme.WHITE))
	state_pressed.set("border_color", API.theme.get_color(API.theme.PD2))
	
	var state_focus: StyleBoxFlat = self.get("custom_styles/focus")
	state_focus.set("bg_color", API.theme.get_color(API.theme.PL1))
	state_focus.set("border_color", API.theme.get_color(API.theme.PD2))
	
	var state_disabled: StyleBoxFlat = self.get("custom_styles/disabled")
	state_disabled.set("bg_color", API.theme.get_color(API.theme.PB))
	state_disabled.set("border_color", API.theme.get_color(API.theme.PD2))
	
	var state_normal: StyleBoxFlat = self.get("custom_styles/normal")
	state_normal.set("bg_color", API.theme.get_color(API.theme.PB))
	state_normal.set("border_color", API.theme.get_color(API.theme.PD2))


func set_secondary_color() -> void:
	self.set("custom_colors/font_color", API.theme.get_color(API.theme.WHITE))
	self.set("custom_colors/font_color_hover", API.theme.get_color(API.theme.WHITE))
	self.set("custom_colors/font_color_pressed", API.theme.get_color(API.theme.SB))
	
	var state_hover: StyleBoxFlat = self.get("custom_styles/hover")
	state_hover.set("bg_color", API.theme.get_color(API.theme.SL1))
	state_hover.set("border_color", API.theme.get_color(API.theme.SD2))
	
	var state_pressed: StyleBoxFlat = self.get("custom_styles/pressed")
	state_pressed.set("bg_color", API.theme.get_color(API.theme.WHITE))
	state_pressed.set("border_color", API.theme.get_color(API.theme.SD2))
	
	var state_focus: StyleBoxFlat = self.get("custom_styles/focus")
	state_focus.set("bg_color", API.theme.get_color(API.theme.SL1))
	state_focus.set("border_color", API.theme.get_color(API.theme.SD2))
	
	var state_disabled: StyleBoxFlat = self.get("custom_styles/disabled")
	state_disabled.set("bg_color", API.theme.get_color(API.theme.SB))
	state_disabled.set("border_color", API.theme.get_color(API.theme.SD2))
	
	var state_normal: StyleBoxFlat = self.get("custom_styles/normal")
	state_normal.set("bg_color", API.theme.get_color(API.theme.SB))
	state_normal.set("border_color", API.theme.get_color(API.theme.SD2))


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

extends Node


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]
export (Texture) var themeTexture
export (Color) var mainColor = Color("#3C977C")

#  [PUBLIC_VARIABLES]
var bgColor : Color

#  [PRIVATE_VARIABLES]
var _primaryColor := {}
var _complementaryColor := {}

var _primaryTheme : Theme
var _complementaryTheme : Theme

#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]


#  [BUILT-IN_VIRTUAL_METHOD]
# Called when the node enters the scene tree for the first time.
func _ready():
#	var primary = Color("#3C977C")
	var primary = mainColor
	var complementary = _get_complementary(primary)
	
	_primaryTheme = $default_color.theme
	_complementaryTheme = $complementary_color.theme
	
	_primaryColor = _gen_dictionary(primary)
	_complementaryColor = _gen_dictionary(complementary)
	
	_set_theme(_primaryColor, _primaryTheme)
	_set_theme(_complementaryColor, _complementaryTheme)
	
	bgColor = _primaryColor["400"]

#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]

#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _gen_dictionary(color: Color) -> Dictionary:
	var output := {"P": color,
					"200": color.lightened(0.6),
					"300": color.lightened(0.4),
					"400": color.lightened(0.2),
					"700": color.darkened(0.2),
					"800": color.darkened(0.4),
					"900": color.darkened(0.6)}
	return output

func _get_complementary(color: Color) -> Color:
	var output := Color().from_hsv(fposmod(color.h + 0.5, 1.0), color.s, color.v)
	return output

func _set_theme(color: Dictionary, theme:Theme) -> void:
	_set_button_theme(color, theme)
	_set_font_theme(color, theme)

func _set_button_theme(color: Dictionary, theme:Theme) -> void:
	## Pressed  ##
	var pressed = theme.get_stylebox("pressed", "Button")
#	pressed.bg_color = color["200"]
	pressed.bg_color = Color.white
	pressed.border_color = color["900"]
	
	## Disabled ##
	var disabled = theme.get_stylebox("disabled", "Button")
	disabled.bg_color = color["200"]
	disabled.border_color = color["300"]
	
#	## Focus    ##
#	var focus = theme.get_stylebox("focus", "Button")
#	focus.bg_color = color["400"]
#	focus.border_color = color["900"]
	
	## Hover    ##
	var hover = theme.get_stylebox("hover", "Button")
	hover.bg_color = color["400"]
	hover.border_color = color["900"]
	
	## Normal   ##
	var normal = theme.get_stylebox("normal", "Button")
	normal.bg_color = color["P"]
	normal.border_color = color["900"]
	
	

func _set_font_theme(color: Dictionary, theme:Theme) -> void:
	theme.set_color("font_color", "Label", color["P"])
	
	theme.set_color("default_color", "RichTextLabel", color["P"])
	
#  [SIGNAL_METHODS]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


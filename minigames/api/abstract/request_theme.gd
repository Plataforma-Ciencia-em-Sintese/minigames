#tool
class_name RequestTheme #, res://class_name_icon.svg
extends Request


#  [DOCSTRING]


#  [SIGNALS]
# warning-ignore:unused_signal
signal all_request_theme_completed


#  [ENUMS]


#  [CONSTANTS]
enum {
	PL3, # PRIMARY LIGHT 3
	PL2, # PRIMARY LIGHT 2
	PL1, # PRIMARY LIGHT 1
	PB,  # PRIMARY BASE
	PD1, # PRIMARY DARK 1
	PD2, # PRIMARY DARK 2
	PD3, # PRIMARY DARK 3
	SL3, # SECONDARY LIGHT 3
	SL2, # SECONDARY LIGHT 2
	SL1, # SECONDARY LIGHT 1
	SB,  # SECONDARY BASE
	SD1, # SECONDARY DARK 1
	SD2, # SECONDARY DARK 2
	SD3, # SECONDARY DARK 3
	RED, # FIXED COLORS
	GREEN, # FIXED COLORS
	BLACK, # FIXED COLORS
	WHITE, # FIXED COLORS
	LIGHTGRAY, # FIXED COLORS
	DARKGRAY, # FIXED COLORS
}


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _primary_color: Color = Color() \
		setget set_primary_color, get_primary_color

var _secondary_color: Color = Color() \
		setget set_secondary_color, get_secondary_color

var _background_texture: ImageTexture = null \
		setget set_background_texture, get_background_texture


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
#func _ready() -> void:
#	pass


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_primary_color(new_value: Color) -> void:
	_primary_color = new_value
	#_primary_color = Color("#33DEEC")


func get_primary_color() -> Color:
	return _primary_color


func set_secondary_color(new_value: Color) -> void:
	_secondary_color = new_value
	#_secondary_color = Color("#EC7333")


func get_secondary_color() -> Color:
	return _secondary_color


func set_background_texture(new_value: ImageTexture) -> void:
	_background_texture = new_value


func get_background_texture() -> ImageTexture:
	return _background_texture


func get_color(name: int) -> Color:
	var color: Color = Color()
	var intensity: float = 0.25
	
	match(name):
		# PRIMARY COLORS
		PL3:
			color = get_primary_color().lightened(intensity * 3.0)
		PL2:
			color = get_primary_color().lightened(intensity * 2.0)
		PL1:
			color = get_primary_color().lightened(intensity)
		PB:
			color = get_primary_color()
		PD1: 
			color = get_primary_color().darkened(intensity)
		PD2: 
			color = get_primary_color().darkened(intensity * 2.0)
		PD3:
			color = get_primary_color().darkened(intensity * 3.0)

		# SECONDARY COLORS
		SL3: 
			color = get_secondary_color().lightened(intensity * 3.0)
		SL2: 
			color = get_secondary_color().lightened(intensity * 2.0)
		SL1: 
			color = get_secondary_color().lightened(intensity)
		SB:  
			color = get_secondary_color()
		SD1:
			color = get_secondary_color().darkened(intensity)
		SD2: 
			color = get_secondary_color().darkened(intensity * 2.0)
		SD3:
			color = get_secondary_color().darkened(intensity * 3.0)
		
		# FIXED COLORS
		RED:
			color = Color("#F5333F")
		GREEN:
			color = Color("#0A9E4E")
		BLACK:
			color = Color("#000000")
		WHITE:
			color = Color("#FFFFFF")
		LIGHTGRAY:
			color = Color("#EFEFEF")
		DARKGRAY:
			color = Color("#898989")

	return color


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

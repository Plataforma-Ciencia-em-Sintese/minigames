tool
extends RichTextLabel


#  [DOCSTRING]


#  [SIGNALS]

#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]
export (DynamicFontData) var override_font_normal
export (DynamicFontData) var override_font_bold
export (DynamicFontData) var override_font_italic
export (DynamicFontData) var override_font_bold_italic
export (int, 1, 256) var override_size = 16


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES] 
var _old_font_normal: DynamicFontData = null
var _old_font_bold: DynamicFontData = null
var _old_font_italic: DynamicFontData = null
var _old_font_bold_italic: DynamicFontData = null
var _old_font_size: int = 0

#var _applied_font_normal: DynamicFont = null
#var _applied_font_bold: DynamicFont = null
#var _applied_font_italic: DynamicFont = null
#var _applied_font_bold_italic: DynamicFont = null

#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
#func _ready() -> void:
#	pass

func _process(delta:float) -> void:
	var changed = _changed_anything()
#	print(self.get_font("bold_font").size)
	if changed:
		print(changed)
		_solve_mismatch()
		pass

#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _changed_anything() -> bool:
	if (override_size != _old_font_size):
		return true
	if (override_font_normal != _old_font_normal):
		return true
	if (override_font_bold != _old_font_bold):
		return true
	if (override_font_italic != _old_font_italic):
		return true
	if (override_font_bold_italic != _old_font_bold_italic):
		return true
	return false

func _generate_fonts() -> Dictionary:
	_old_font_size = override_size
#	self.font
	var output := {}
	return output

func _solve_mismatch() -> void:
	_old_font_size = override_size
	_old_font_normal = override_font_normal
	_old_font_bold = override_font_bold
	_old_font_bold_italic = override_font_bold_italic
	_old_font_italic = override_font_italic

#  [SIGNAL_METHODS]

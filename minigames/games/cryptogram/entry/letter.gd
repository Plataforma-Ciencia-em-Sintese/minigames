extends Panel


#  [DOCSTRING]


#  [SIGNALS]
#signal symbol_change
signal selected

#  [ENUMS]

#  [CONSTANTS]


#  [EXPORTED_VARIABLES]

#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]

#  [ONREADY_VARIABLES]
onready var Raiz : Control = find_parent("Raiz")
onready var pic : Label = $letter/pic
onready var letter : Button = $letter/letter
onready var pan : Panel = get_node("../../../..")

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]#9CF2D3
#func _init() -> void:
#	passletter/


#  [BUILT-IN_VIRTUAL_METHOD]
func _ready():
	_update_theme()
	pan.connect("resized", self, "_resize_tip")
	Raiz.connect("table_filled", self, "_invert_color")
	Raiz.connect("table_reset_color", self, "_update_theme")


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]




#  [PRIVATE_METHODS]

func _update_theme() -> void:
	# Background Panel
	var panel : StyleBoxFlat = self.get("custom_styles/panel")
#	panel.bg_color = API.theme.get_color(API.theme.PL2)
#	panel.border_color = API.theme.get_color(API.theme.PB)
#	panel.border_color = API.theme.get_color(API.theme.PD1)
	
	# Label theme
	pic.set("custom_colors/font_color", API.theme.get_color(API.theme.PL1))
	
	# Button Theme
	var hover : StyleBoxFlat = letter.get("custom_styles/hover")
	var press : StyleBoxFlat = letter.get("custom_styles/pressed")
	var focus : StyleBoxFlat = letter.get("custom_styles/focus")
	var disab : StyleBoxFlat = letter.get("custom_styles/disabled")
	var norma : StyleBoxFlat = letter.get("custom_styles/normal")
	
	var alpha_col : Color = Color(00,00,00,00)
	
	hover.bg_color = API.theme.get_color(API.theme.PL2)
	hover.border_color = API.theme.get_color(API.theme.PD1)
	press.bg_color = API.theme.get_color(API.theme.PL2)
	press.border_color = API.theme.get_color(API.theme.PD1)
	focus.bg_color = API.theme.get_color(API.theme.PL2)
	focus.border_color = API.theme.get_color(API.theme.PD1)
#	disab.bg_color = API.theme.get_color(API.theme.PD2)
	disab.bg_color = alpha_col
	disab.border_color = API.theme.get_color(API.theme.PD1)
#	norma.bg_color = API.theme.get_color(API.theme.PB)
	norma.bg_color = alpha_col
	norma.border_color = API.theme.get_color(API.theme.PD1)
	
	letter.set("custom_colors/font_color", API.theme.get_color(API.theme.PD2))
	letter.set("custom_colors/font_color_focus", API.theme.get_color(API.theme.PD2))
	letter.set("custom_colors/font_color_disabled", API.theme.get_color(API.theme.PD2))
	letter.set("custom_colors/font_color_hover", API.theme.get_color(API.theme.PD2))
	letter.set("custom_colors/font_color_pressed", API.theme.get_color(API.theme.PD2))

func _update_invert_color():
	# Label theme
	pic.set("custom_colors/font_color", API.theme.get_color(API.theme.SL1))
	
	var hover : StyleBoxFlat = letter.get("custom_styles/hover")
	var press : StyleBoxFlat = letter.get("custom_styles/pressed")
	var focus : StyleBoxFlat = letter.get("custom_styles/focus")
	var disab : StyleBoxFlat = letter.get("custom_styles/disabled")
	var norma : StyleBoxFlat = letter.get("custom_styles/normal")
	
	var alpha_col : Color = Color(00,00,00,00)
	
	hover.bg_color = API.theme.get_color(API.theme.SL2)
	hover.border_color = API.theme.get_color(API.theme.SD1)
	press.bg_color = API.theme.get_color(API.theme.SL2)
	press.border_color = API.theme.get_color(API.theme.SD1)
	focus.bg_color = API.theme.get_color(API.theme.SL2)
	focus.border_color = API.theme.get_color(API.theme.SD1)
#	disab.bg_color = API.theme.get_color(API.theme.PD2)
	disab.bg_color = alpha_col
	disab.border_color = API.theme.get_color(API.theme.SD1)
#	norma.bg_color = API.theme.get_color(API.theme.PB)
	norma.bg_color = alpha_col
	norma.border_color = API.theme.get_color(API.theme.SD1)
	
	letter.set("custom_colors/font_color", API.theme.get_color(API.theme.SD2))
	letter.set("custom_colors/font_color_focus", API.theme.get_color(API.theme.SD2))
	letter.set("custom_colors/font_color_disabled", API.theme.get_color(API.theme.SD2))
	letter.set("custom_colors/font_color_hover", API.theme.get_color(API.theme.SD2))
	letter.set("custom_colors/font_color_pressed", API.theme.get_color(API.theme.SD2))

func _invert_color() -> void:
#	print("cor")
	if (letter.text != Raiz.get_correct_letter(pic.text)):
		_update_invert_color()

func _selected() -> void:
	Raiz.set_selected_symbol(pic.text)

#  [SIGNAL_METHODS]


func _on_letter_pressed():
	var p = pic.text
#	printt(len(Raiz.SYMBOL_LIST), Raiz.SYMBOL_LIST.find(p))
	emit_signal("selected")
	_selected()

func _on_solution_changed():
	letter.text = Raiz.get_new_solution(pic.text)

func _resize_tip() -> void:
	var size : float = pan.rect_size.x
	# o valor de size sera 1760 quando a tela estiver em 1080p
	var font : DynamicFont = pic.get("custom_fonts/font")
	# Quando o size for 1760 o tamanho da fonte sera 57
	font.size = ceil(size/30.877)
	# O espacamento sera de -15 quando size for 1760
	font.extra_spacing_top = ceil(-size/117.333)
	
	# A letra sera de 24 quando size for 1760
	font = letter.get("custom_fonts/font")
	font.size = ceil(size/73.333)


func _on_letter_focus_entered():
	_on_letter_pressed()

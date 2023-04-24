extends Panel


#  [DOCSTRING]


#  [SIGNALS]
#  [ENUMS]

#  [CONSTANTS]


#  [EXPORTED_VARIABLES]
export (float, 0.1, 0.9) var proporcao = 0.23

#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]

#  [ONREADY_VARIABLES]
onready var Raiz : Control = find_parent("Raiz")
onready var box : HBoxContainer = $Entry
#onready var tip : RichTextLabel = $Entry/Tip
onready var tip : RichTextLabel = $Entry/Tip
#onready var container : AspectRatioContainer = Raiz.find_node("AspectRatioContainer")
onready var pan : Panel = get_node("../..")

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	passletter/


#  [BUILT-IN_VIRTUAL_METHOD]
func _ready():
	_update_theme()
#	print(pan)
#	print(container)
#	self.connect("resized_tip", container, "resized")
	pan.connect("resized", self, "_resize_tip")


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]




#  [PRIVATE_METHODS]
func _update_theme() -> void:
#	print(API.theme.get_color(API.theme.PD1))
	var panel : StyleBoxFlat = self.get("custom_styles/panel")
	panel.bg_color = API.theme.get_color(API.theme.PL2)
#	panel.border_color = API.theme.get_color(API.theme.PB)
#	panel.border_color = API.theme.get_color(API.theme.PD1)
	panel.border_color = Color(0, 0, 0, 0)
	
	tip.set("custom_colors/default_color", API.theme.get_color(API.theme.BLACK))

#  [SIGNAL_METHODS]
func _resize_tip() -> void:
#	var size : float = container.rect_size.x
	var size : float = pan.rect_size.x
	tip.rect_min_size.x = size * proporcao
	self.rect_min_size.x = size * proporcao

#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]
signal closed


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _textures: Array = Array([]) \
		setget set_textures, get_textures

var _current_page: int = int(0) \
		setget set_current_page, get_current_page


#  [ONREADY_VARIABLES]
onready var label: Label = $MarginContainer/VBoxContainer/Panel/Label
onready var indicators: HBoxContainer = $MarginContainer/VBoxContainer/Panel/MarginContainer2/HBoxContainer/Indicators
onready var page_texture: TextureRect = $MarginContainer/VBoxContainer/Panel/MarginContainer/PageTexture
onready var previous: Button = $MarginContainer/VBoxContainer/Panel/MarginContainer2/HBoxContainer/Previous
onready var next: Button = $MarginContainer/VBoxContainer/Panel/MarginContainer2/HBoxContainer/Next
onready var carousel: MarginContainer = $MarginContainer/VBoxContainer/Panel/MarginContainer2


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
func set_textures(new_value: Array) -> void:
	_textures = new_value
	
	_update_page()
	_create_indicators()
	_update_indicators()
	
	if get_textures().empty():
		carousel.visible = false
	else:
		carousel.visible = true


func get_textures() -> Array:
	return _textures


func set_current_page(new_value: int) -> void:
	_current_page = new_value


func get_current_page() -> int:
	return _current_page


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	label.set("custom_colors/font_color", API.theme.get_color(API.theme.PD1))
	var state_normal: StyleBoxFlat = label.get("custom_styles/normal")
	state_normal.set("border_color", API.theme.get_color(API.theme.PD1))


func _create_indicators() -> void:
	if indicators.get_children().size() < get_textures().size():
		while indicators.get_children().size() < get_textures().size():
			
			var style: StyleBoxFlat = StyleBoxFlat.new()
			style.set("bg_color", Color("999999"))
			style.set("corner_radius_top_left", 50.0)
			style.set("corner_radius_top_right", 50.0)
			style.set("corner_radius_bottom_right", 50.0)
			style.set("corner_radius_bottom_left", 50.0)
			
			var new_indicator: Panel = Panel.new()
			new_indicator.set("rect_min_size", Vector2(20.0, 20.0))
			new_indicator.set("custom_styles/panel", style)
			
			indicators.add_child(new_indicator)


func _update_indicators() -> void:
	for indicator in indicators.get_children():
		var style: StyleBoxFlat = indicator.get("custom_styles/panel")
		style.set("bg_color", Color("999999"))
		
	var style: StyleBoxFlat = indicators.get_child(get_current_page()).get("custom_styles/panel")
	style.set("bg_color", API.theme.get_color(API.theme.PB))


func _update_page() -> void:
	page_texture.texture = get_textures()[get_current_page()]


func _update_buttons() -> void:
	var max_pages: int = get_textures().size() - 1
	
	match(_current_page):
		0:
			next.disabled = false
			next.set("modulate", Color(1.0, 1.0, 1.0, 1.0))
			previous.disabled = true
			previous.set("modulate", Color(0.0, 0.0, 0.0, 0.0))
		
		max_pages:
			next.disabled = true
			next.set("modulate", Color(0.0, 0.0, 0.0, 0.0))
			previous.disabled = false
			previous.set("modulate", Color(1.0, 1.0, 1.0, 1.0))
		
		_:
			previous.disabled = false
			previous.set("modulate", Color(1.0, 1.0, 1.0, 1.0))
			next.disabled = false
			next.set("modulate", Color(1.0, 1.0, 1.0, 1.0))


#  [SIGNAL_METHODS]
func _on_Button_pressed() -> void:
	emit_signal("closed")
	queue_free()


func _on_Previous_pressed() -> void:
	if get_current_page() > 0:
		set_current_page(get_current_page() - 1)
	else:
		set_current_page(get_textures().size() - 1)
	
	_update_indicators()
	_update_page()
	_update_buttons()


func _on_Next_pressed() -> void:
	if get_current_page() < get_textures().size() - 1:
		set_current_page(get_current_page() + 1)
	else:
		set_current_page(0)
	
	_update_indicators()
	_update_page()
	_update_buttons()


#func _on_Timer_timeout() -> void:
#	if get_current_page() < get_textures().size() - 1:
#		set_current_page(get_current_page() + 1)
#	else:
#		set_current_page(0)
#
#	_update_indicators()
#	_update_page()
#	_update_buttons()

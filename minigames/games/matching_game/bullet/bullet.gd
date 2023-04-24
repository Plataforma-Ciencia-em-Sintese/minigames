#tool
#class_name Name #, res://class_name_icon.svg
extends TextureButton


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]
enum State {INCOMPLETE, COMPLETE}


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _current_state: int = State.INCOMPLETE \
		setget set_current_state, get_current_state

var _matching_id: int = int(0) \
		setget set_matching_id, get_matching_id

var _subtitle: String = String("") \
		setget set_subtitle, get_subtitle


#  [ONREADY_VARIABLES]
onready var subtitle: Label = $Label


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	subtitle.visible = false


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_current_state(new_value: int) -> void:
	_current_state = new_value
	
	match(_current_state):
		
		State.INCOMPLETE:
			subtitle.visible = false
			subtitle.text = ""
			set("self_modulate", Color(1.0, 1.0, 1.0, 1.0))
			
		State.COMPLETE:
			subtitle.visible = true
			set("self_modulate", Color(1.0, 1.0, 1.0, 0.5))
			_self_check()
			


func get_current_state() -> int:
	return _current_state


func set_matching_id(new_value: int) -> void:
	_matching_id = new_value


func get_matching_id() -> int:
	return _matching_id


func set_subtitle(new_value: String) -> void:
	_subtitle = new_value
	
	subtitle.text = _subtitle


func get_subtitle() -> String:
	return _subtitle


func create(image: ImageTexture, matching_id: int, subtitle: String = String("")) -> void:
	texture_normal = image
	set_matching_id(matching_id)
	set_subtitle(subtitle)


func get_drag_data(_position: Vector2) -> Dictionary:
	if get_current_state() == State.INCOMPLETE:
		var preview: Control = Control.new()
		
		var color_rect: ColorRect = ColorRect.new()
		preview.add_child(color_rect)
		color_rect.rect_size = Vector2(160, 160)
		color_rect.rect_position -= color_rect.rect_size / 2
		color_rect.color = Color(1.0, 0.0, 0.0, 0.0)
		
		var preview_texture: TextureRect = TextureRect.new()
		color_rect.add_child(preview_texture)
		preview_texture.texture = texture_normal
		preview_texture.rect_min_size = Vector2(100, 100)
		preview_texture.expand = true
		preview_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		preview_texture.anchor_right = 1
		preview_texture.anchor_bottom = 1
		preview_texture.set("modulate", Color(1.0, 1.0, 1.0, 0.8))
		
		set_drag_preview(preview)
		
		return {
			"bullet": self,
			"image": texture_normal, 
			"matching_id": get_matching_id(), 
			"subtitle": get_subtitle()
		}
	
	return {}


#  [PRIVATE_METHODS]
func _self_check() -> void:
	if self.get_parent() is MarginContainer:
		if self.get_parent().get_parent() is PanelContainer:
			var parent_panel: PanelContainer = self.get_parent().get_parent()
			var parent_panel_style: StyleBoxFlat = parent_panel.get("custom_styles/panel")
			parent_panel_style.set("bg_color", API.theme.get_color(API.theme.GREEN))
 

#  [SIGNAL_METHODS]

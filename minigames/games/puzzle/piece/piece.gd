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
var _id: int = int(0) \
		setget set_id, get_id

var _free_piece: bool = bool(true) \
		setget set_free_piece, get_free_piece


#  [ONREADY_VARIABLES]
onready var image: TextureRect = $TextureRect


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
func set_id(new_value: int) -> void:
	_id = new_value


func get_id() -> int:
	return _id


func set_free_piece(new_value: bool) -> void:
	_free_piece = new_value


func get_free_piece() -> bool:
	return _free_piece


func get_drag_data(_position: Vector2) -> Dictionary:
	image.set("self_modulate", Color(1.0, 1.0, 1.0, 0.0))

	var preview: Control = Control.new()

	var color_rect: ColorRect = ColorRect.new()
	preview.add_child(color_rect)
	color_rect.rect_size = self.rect_size #Vector2(160, 160)
	color_rect.rect_position -= color_rect.rect_size / 2
	color_rect.color = Color(1.0, 0.0, 0.0, 0.0)

	var preview_texture: TextureRect = TextureRect.new()
	color_rect.add_child(preview_texture)
	preview_texture.texture = self.image.texture
	preview_texture.material = self.image.material
	preview_texture.expand = true
	preview_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview_texture.anchor_right = 1
	preview_texture.anchor_bottom = 1

	preview.connect("tree_exited", self, "_on_Preview_tree_exited")

	set_drag_preview(preview)
	
	return {"piece": self}


func can_drop_data(position: Vector2, data) -> bool:
	return false


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]
func _on_Preview_tree_exited() -> void:
	image.set("self_modulate", Color(1.0, 1.0, 1.0, 1.0))

	var mouse_position: Vector2 = get_global_mouse_position()
	var parent_position: Vector2 = get_parent().rect_global_position + self.rect_size/2
	var parent_size: Vector2 = get_parent().rect_size - self.rect_size

	# free area to drop
	if (mouse_position.x > parent_position.x and \
			mouse_position.x < parent_position.x + parent_size.x) \
			and (mouse_position.y > parent_position.y and \
			mouse_position.y < parent_position.y + parent_size.y):
		self.rect_global_position = mouse_position - self.rect_size/2

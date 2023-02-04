#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]
const ROUNDED_EDGES: Shader = preload("res://assets/shader/rounded_edges.shader")


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]
onready var grid_slots: GridContainer = $MarginContainer/VBoxContainer/GameContainer/Panel/MarginContainer/Panel/GridContainer


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	var texture: ImageTexture = API.game.get_texture_images()[0]
#	var texture: StreamTexture = load("res://games/puzzle/default1.png")
	var width: float = texture.get_width()
	var height: float = texture.get_height()
	
	var index: int = int(0)
	for slot in grid_slots.get_children():
		var texture_rect: TextureRect = slot.get_child(0)
		var atlas_texture: AtlasTexture = AtlasTexture.new()
		atlas_texture.atlas = texture
		
		match(index):
			0: atlas_texture.region = Rect2(0.0, 0.0, width/4.0, height/4.0)
			
			1: atlas_texture.region = Rect2(width/4.0, 0.0, width/4.0, height/4.0)
			
			2: atlas_texture.region = Rect2((width/4.0)*2.0, 0.0, width/4.0, height/4.0)
			
			3: atlas_texture.region = Rect2((width/4.0)*3.0, 0.0, width/4.0, height/4.0)
			
			4: atlas_texture.region = Rect2(0.0, height/4.0, width/4.0, height/4.0)
			
			5: atlas_texture.region = Rect2(width/4.0, height/4.0, width/4.0, height/4.0)
			
			6: atlas_texture.region = Rect2((width/4.0)*2.0, height/4.0, width/4.0, height/4.0)
			
			7: atlas_texture.region = Rect2((width/4.0)*3.0, height/4.0, width/4.0, height/4.0)
			
			8: atlas_texture.region = Rect2(0.0, (height/4.0)*2.0, width/4.0, height/4.0)
			
			9: atlas_texture.region = Rect2(width/4.0, (height/4.0)*2.0, width/4.0, height/4.0)
			
			10: atlas_texture.region = Rect2((width/4.0)*2.0, (height/4.0)*2.0, width/4.0, height/4.0)
			
			11: atlas_texture.region = Rect2((width/4.0)*3.0, (height/4.0)*2.0, width/4.0, height/4.0)
			
			12: atlas_texture.region = Rect2(0.0, (height/4.0)*3.0, width/4.0, height/4.0)
			
			13: atlas_texture.region = Rect2(width/4.0, (height/4.0)*3.0, width/4.0, height/4.0)
			
			14: atlas_texture.region = Rect2((width/4.0)*2.0, (height/4.0)*3.0, width/4.0, height/4.0)
			
			15: atlas_texture.region = Rect2((width/4.0)*3.0, (height/4.0)*3.0, width/4.0, height/4.0)
		
		texture_rect.texture = atlas_texture
		index += 1


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

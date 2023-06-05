extends TextureRect


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]
enum IMAGE{
	GAME_LOGO,
	MASCOT,
	PET
}

#  [CONSTANTS]


#  [EXPORTED_VARIABLES]
export(IMAGE) var selected_data: int = IMAGE.GAME_LOGO

#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
func _enter_tree() -> void:
#func _ready() -> void:
	var data : ImageTexture
	match selected_data:
		IMAGE.GAME_LOGO:
			data = API.common.get_game_logo()
		IMAGE.MASCOT:
			data = API.common.get_mascot()
		IMAGE.PET:
			data = API.common.get_pet()
#	self.set_texture(data)
	if data != null:
		call_deferred("set_texture", data)

#  [BUILT-IN_VIRTUAL_METHOD]



#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]



#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

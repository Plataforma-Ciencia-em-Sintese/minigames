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


#  [ONREADY_VARIABLES]
onready var animation := $AnimationPlayer
onready var image_logo := $Logos

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	image_logo.texture = API.common.get_sponsors_logo()
	
	animation.play("fade")
	yield(animation, "animation_finished")
	
	var parameters: Dictionary = URL.get_parameters("https://.../?id=23391&skip=0")
	if parameters.has("skip"):
		match(int(parameters["skip"])):
			0:
				if API.common.get_article_summary() == "":
					get_tree().change_scene("res://home/home.tscn")
				else:
					get_tree().change_scene("res://resume/resume.tscn")
			1:
				get_tree().change_scene("res://home/home.tscn")
			_:
				if API.common.get_article_summary() == "":
					get_tree().change_scene("res://home/home.tscn")
				else:
					get_tree().change_scene("res://resume/resume.tscn")
	else:
		if API.common.get_article_summary() == "":
			get_tree().change_scene("res://home/home.tscn")
		else:
			get_tree().change_scene("res://resume/resume.tscn")



#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]


#  [SIGNAL_METHODS]

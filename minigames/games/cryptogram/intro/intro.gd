extends Control


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]


#  [BUILT-IN_VIRTUAL_METHOD]
func _ready() -> void:
	var descrition = $Panel/VBoxContainer/lom_description
	descrition.set_text(API.common.get_article_summary())


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]



#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]


func _on_enter_pressed():
	get_tree().change_scene("res://home/home.tscn")


func _on_credits_pressed():
	get_tree().change_scene("res://credits/credits.tscn")

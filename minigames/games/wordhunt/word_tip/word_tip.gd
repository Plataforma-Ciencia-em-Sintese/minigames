#tool
#class_name Name #, res://class_name_icon.svg
extends MarginContainer


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]
onready var _tip: RichTextLabel = $MarginContainer/VBoxContainer/Tip
onready var _letter_counter: RichTextLabel = $MarginContainer/VBoxContainer/LetterCounter
onready var _word: RichTextLabel = $MarginContainer/VBoxContainer/Word


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
func get_tip() -> RichTextLabel:
	return _tip


func get_letter_counter() -> RichTextLabel:
	return _letter_counter


func get_word() -> RichTextLabel:
	return _word


#  [PRIVATE_METHODS]
func set_tip_text(text: String) -> void:
	get_tip().set_bbcode(text)


func set_letter_counter_text(text: String) -> void:
	get_letter_counter().set_bbcode(text)


func set_word_text(text: String) -> void:
	get_word().set_bbcode(text)


#  [SIGNAL_METHODS]

extends Panel


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]
const _VALID_KEYS := {'Q': 81, 'W': 87, 'E': 69, 'R': 82, 'T': 84, 'Y': 89, 'U': 85, 'I': 73, 'O': 79, 'P': 80, 'A': 65, 'S': 83, 'D': 68, 'F': 70, 'G': 71, 'H': 72, 'J': 74, 'K': 75, 'L': 76, 'Z': 90, 'X': 88, 'C': 67, 'V': 86, 'B': 66, 'N': 78, 'M': 77, 'ç': 59, 'backspace': 16777220}

#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _drag_or_drop := false
var _buttons := {}
var _actual_keys := []

#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VIRTUAL_METHOD]
func _ready() -> void:
	var letter_index := 0
	for i in $VBoxContainer/AspectRatioContainer/GridContainer.get_children():
		var button_i = i.get_child(0) as Button
		_buttons[i.name] = {"parent": i, "button": button_i, "key": ""}
		button_i.connect("pressed", self, "_key_pressed", [button_i])
		if (i.name == "backspace"):
			_buttons[i.name]["key"] = "backspace"
			letter_index -= 1
		elif (letter_index < len(API.get_keyset())):
			_buttons[i.name]["key"] = API.get_keyset()[letter_index]
			_buttons[i.name]["button"].text = API.get_keyset()[letter_index]
		else:
			i.hide()
		letter_index += 1
		
#		print(i)
#	print(len(_buttons))
#	print(_buttons)

func _input(event):
	if event is InputEventMouseMotion:
		event as InputEventMouseMotion
		if _drag_or_drop:
			self.rect_position += event.get_relative()
#			print(event.get_relative())


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func update_keyset(keyset: Array):
	var index = 0
	for i in _buttons:
		_buttons[i]["key"] = keyset[index]
		_buttons[i]["button"].text = keyset[index]
		index += 1
		

#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]

func _switch_visibility():
	if self.is_visible():
		self.call_deferred("hide")
	else:
		self.call_deferred("show")

func _on_Fechar_pressed():
	var vish = InputEventKey.new()
	vish.set_scancode(81)
	vish.set_physical_scancode(81)
	vish.set_pressed(true)
	get_tree().input_event(vish)



func _drop_keyboard():
	_drag_or_drop = false


func _drag_keyboard():
	_drag_or_drop = true


func _reduce_keyboard():
	self.rect_size -= Vector2(20, 20)


func _grow_keyboard():
	self.rect_size += Vector2(20, 20)


func _key_pressed(pressed_key: Button):
	var index = pressed_key.get_parent().name
	var value = _buttons[index]
	var new_event = InputEventKey.new()
	if value["key"] != "":
		new_event.set_pressed(true)
		new_event.set_physical_scancode(_VALID_KEYS[value["key"]])
		new_event.set_scancode(_VALID_KEYS[value["key"]])
		get_tree().input_event(new_event)
		var flush_event = InputEventKey.new()
		get_tree().input_event(flush_event)
	



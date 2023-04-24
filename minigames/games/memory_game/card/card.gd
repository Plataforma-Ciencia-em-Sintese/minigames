#tool
#class_name Name #, res://class_name_icon.svg
extends TextureButton


#  [DOCSTRING]


#  [SIGNALS]
signal card_turned(card)
signal turnning_completed


#  [ENUMS]
enum State {FRONT, BACK, TURNNING, COMPLETED}


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _state: int = State.FRONT \
		setget set_state, get_state

var  _id: int = 0 \
		setget set_id, get_id

var _front_image = null \
		setget set_front_image, get_front_image

var _back_image = null \
		setget set_back_image, get_back_image

var _current_image: int = State.FRONT

var _subtitle: String = "#" \
		setget set_subtitle, get_subtitle 


#  [ONREADY_VARIABLES]
onready var animation := $AnimationPlayer
onready var subtitle_label := $Subtitle
onready var lock_card_label := $LockCard
onready var back_color := $BackColor


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()
	#set_front_image(load("res://assets/placeholder.png"))
	set_back_image(load("res://assets/placeholder.png"))
	#texture_normal = get_front_image()



#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_state(new_state: int) -> void:
	match(new_state): # enum State {FRONT, BACK, TURNNING, COMPLETED}
		State.FRONT:
			_state = new_state
			_current_image = new_state
			self_modulate = Color(1.0, 1.0, 1.0, 1.0) 
		
		State.BACK:
			_state = new_state
			_current_image = new_state
			subtitle_label.visible = false
			self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		
		State.TURNNING:
			_state = new_state
		
		State.COMPLETED:
			_state = new_state
			#lock_card_label.visible = false
			disabled = true
			back_color.disabled = true
			subtitle_label.visible = true
			self_modulate = Color(0.65, 0.65, 0.65, 1.0) 
		_:
			pass

#		State.FRONT:
#			set_card_image(_card_front_image)
			
#		State.BACK:
#			set_card_image(_card_back_image)
			 


func get_state() -> int:
	return _state


func set_id(new_value: int) -> void:
	_id = new_value


func get_id() -> int:
	return _id


func set_front_image(new_front_image) -> void:
	_front_image = new_front_image
	texture_normal = new_front_image


func get_front_image():
	return _front_image


func set_back_image(new_back_image) -> void:
	_back_image = new_back_image


func get_back_image():
	return _back_image


func set_subtitle(new_subtitle: String) -> void:
	_subtitle = new_subtitle
	subtitle_label.text = new_subtitle

func get_subtitle() -> String:
	return _subtitle


func turn_animation() -> void:
	match(get_state()): # enum State {FRONT, BACK, TURNNING, COMPLETED}
		State.FRONT:
			set_state(State.TURNNING)
			animation.play("turn")
			yield(animation, "animation_finished")
			set_state(State.BACK)
		
		State.BACK:
			set_state(State.TURNNING)
			animation.play_backwards("turn")
			yield(animation, "animation_finished")
			set_state(State.FRONT)
	
	emit_signal("turnning_completed")


#  [PRIVATE_METHODS]
func _load_theme():
	var back_color_pressed: StyleBoxFlat = back_color.get("custom_styles/pressed")
	back_color_pressed.set("bg_color", API.theme.get_color(API.theme.SB))
	
	var back_color_normal: StyleBoxFlat = back_color.get("custom_styles/normal")
	back_color_normal.set("bg_color", API.theme.get_color(API.theme.SB))


func _exchange_images() -> void:
	match(_current_image): # enum State {FRONT, BACK, TURNNING, COMPLETED}
		State.FRONT:
			back_color.visible = true
			texture_normal = _back_image
		State.BACK:
			back_color.visible = false
			texture_normal = _front_image
		_:
			pass


func _calculate_pivot_offset() -> void:
	rect_pivot_offset.x = rect_size.x / 2
	rect_pivot_offset.y = rect_size.y / 2
 

#  [SIGNAL_METHODS]
func _on_CardButton_pressed() -> void:
	disabled = true
	back_color.disabled = true
	#lock_card_label.visible = true
	turn_animation()
	emit_signal("card_turned", self)





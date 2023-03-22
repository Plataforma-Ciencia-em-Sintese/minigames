#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]
signal start_timer


#  [ENUMS]


#  [CONSTANTS]
var GRID_SIZE: int = 16


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _timer_has_started: bool = false \
		setget set_timer_has_starded, get_timer_has_started

var _timer_counter: int = 0 \
		setget set_timer_counter, get_timer_counter

var _failed_attempt: int = 0 \
		setget set_failed_attempt, get_failed_attempt

var _combinations: Array = [
	0, 
] 


#  [ONREADY_VARIABLES]
onready var grid_slots: GridContainer = $MarginContainer/VBoxContainer/GameContainer/Panel/MarginContainer/Panel/GridContainer
onready var pieces: Panel = $MarginContainer/VBoxContainer/GameContainer/Panel/DropFree
onready var timer: Timer = $Timer
onready var timer_label: Label = $MarginContainer/VBoxContainer/BarContainer/Container/Time


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_all_textures()
	
	for index in range(0, GRID_SIZE):
		if grid_slots.get_child(index) is Panel:
			grid_slots.get_child(index).connect("occupied", self, "_on_Slot_occupied")
		if pieces.get_child(index) is Control:
			pieces.get_child(index).connect("dropped", self, "_on_Piece_dropped")


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_timer_has_starded(new_value: bool) -> void:
	_timer_has_started = new_value


func get_timer_has_started() -> bool:
	return _timer_has_started


func set_timer_counter(new_value: int) -> void:
	_timer_counter = new_value


func get_timer_counter() -> int:
	return _timer_counter


func set_failed_attempt(new_value: int) -> void:
	_failed_attempt = new_value


func get_failed_attempt() -> int:
	return _failed_attempt


#  [PRIVATE_METHODS]
func _load_all_textures() -> void:
	# Loads the image of the API
	var texture: ImageTexture = API.game.get_texture_images()[0]
	
	# Loads a local image (test)
#	var texture: StreamTexture = load("res://games/puzzle/default1.png")
	
	# Calculate the dimensions of the image
	var width: float = texture.get_width()
	var height: float = texture.get_height()
	
	# Divides the texture into Atlas and creates the help images and init of pieces
	var index: int = int(0)
	for slot in grid_slots.get_children():
		var texture_rect: TextureRect = slot.get_child(0)
		var atlas_texture: AtlasTexture = AtlasTexture.new()
		atlas_texture.atlas = texture
		
		# Calculates the position of each atlas
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
		
		# Create the image of help
		texture_rect.texture = atlas_texture
		
		# Create the images of piece
		pieces.get_child(index).image.texture = atlas_texture
		pieces.get_child(index).image.material = texture_rect.material
		pieces.get_child(index).rect_size = texture_rect.rect_size
		
		# Create ID
		slot.set_id(index)
		pieces.get_child(index).set_id(index)
		
		index += 1


func _checks_combinations() -> void:
	var all_combined: bool = true
	var index: int = 0
	
	print("\n--------")
	for slot in grid_slots.get_children():
		
		slot.check_dropped_piece()
		
		if slot.get_dropped_piece() == null:
			print("slot ", index, ": EMPTY")
			all_combined = false
		elif slot.get_id() == slot.get_dropped_piece().get_id():
			print("slot ", index, ": OK ", slot.get_dropped_piece())
		else:
			print("slot ", index, ": ERROR ", slot.get_dropped_piece())
			all_combined = false
		
		index += 1
	
	if all_combined:
		timer.stop()
		print("\n-------------\nRESULTADO")
		print("tentativas: ", get_failed_attempt())
		print("tempo: ", timer_label.text)
		yield(get_tree().create_timer(3.0), "timeout")
		get_tree().change_scene("res://games/puzzle/puzzle.tscn")


#  [SIGNAL_METHODS]
func _on_Timer_timeout() -> void:
	var seconds: int = get_timer_counter()
	seconds += 1
	set_timer_counter(seconds)
	
# warning-ignore:integer_division
	timer_label.text = "%02d:%02d" % [(seconds/60) % 60, seconds % 60]


func _on_Slot_occupied(slot: Panel, piece: Control) -> void:
	if get_timer_has_started() == false:
		timer.start()
		set_timer_has_starded(true)
	
	# count failed attempt
	if slot.get_id() != piece.get_id():
		set_failed_attempt(get_failed_attempt() + 1)
	
	_checks_combinations()


func _on_Piece_dropped(piece: Control) -> void:
	pass

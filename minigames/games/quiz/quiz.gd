#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]
signal end_game



#  [ENUMS]
enum State {FREE=0, WAITING=1}
enum PetImage {IDLE=0, HAPPY=1, LOSER=2}


#  [CONSTANTS]
const GAME_RESULTS: PackedScene = preload("res://game_results/game_results.tscn")
const HOW_TO_PLAY: PackedScene = preload("res://how_to_play/how_to_play.tscn")
const HOW_TO_PLAY_TEXTURES: Array = Array([
	preload("res://assets/images/htp_quiz_0.png")
])


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _state: int = State.FREE \
		setget set_state, get_state

var _waiting_seconds: float = float(2) \
		setget set_waiting_seconds, get_waiting_seconds

var _total_questions: int = int(0) \
		setget set_total_questions, get_total_questions
		
var _current_question: int = int(0) \
		setget set_current_question, get_current_question

var _tip_counter: int = int(3) \
		setget set_tip_counter, get_tip_counter

var _point_counter: int = int(0) \
		setget set_point_counter, get_point_counter


var _pet_images_state: Dictionary = Dictionary({
	"idle": load("res://games/quiz/Group 90.png"),
	"happy": load("res://games/quiz/Group 92.png"),
	"loser": load("res://games/quiz/Group 91.png")
}) setget set_pet_images_state, get_pet_images_state


#  [ONREADY_VARIABLES]
onready var question_container: VBoxContainer = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer
onready var conter_questions: Label = $MarginContainer/VBoxContainer/BarContainer/Container/Counter
onready var question: Label = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Question
onready var alternative_1: Control = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Alternative1
onready var alternative_2: Control = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Alternative2
onready var alternative_3: Control = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Alternative3
onready var alternative_4: Control = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/pergunta/QuestionContainer/Alternative4
onready var tip: Button = $MarginContainer/VBoxContainer/BarContainer/HBoxContainer/Tip
onready var tip_counter: Label = $MarginContainer/VBoxContainer/BarContainer/HBoxContainer/Tip/Counter
onready var pet_background: TextureRect = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/AspectRatioContainer/Background
onready var pet_image: TextureRect = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/AspectRatioContainer/Pet
onready var question_image: TextureRect = $MarginContainer/VBoxContainer/GameContainer/MarginContainer/HBoxContainer/AspectRatioContainer/QuestionImage


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()
	pet_image.texture = get_pet_images_state()["idle"]
	
	_load_current_question()
	set_total_questions(int( API.game.get_questions().size())) 
	
	connect("end_game", self, "_on_Self_end_game")
	
	alternative_1.connect("pressed", self, "_on_Alternative1_Button_pressed")
	alternative_2.connect("pressed", self, "_on_Alternative2_Button_pressed")
	alternative_3.connect("pressed", self, "_on_Alternative3_Button_pressed")
	alternative_4.connect("pressed", self, "_on_Alternative4_Button_pressed")
	
	tip_counter.text = str(get_tip_counter())

#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_state(new_value: int) -> void:
	if new_value in [State.FREE, State.WAITING]:
		_state = new_value


func get_state() -> int:
	return _state


func set_total_questions(new_value: int) -> void:
	_total_questions = new_value
	conter_questions.text = "Pergunta: %s/%s" % [str(get_current_question() + 1), str(new_value)]


func get_total_questions() -> int:
	return _total_questions


func set_current_question(new_value: int) -> void:
	_current_question = new_value
	conter_questions.text = "Pergunta: %s/%s" % [str(new_value + 1), str(get_total_questions())]


func get_current_question() -> int:
	return _current_question


func set_tip_counter(new_value: int) -> void:
	_tip_counter = new_value
	tip_counter.text = str(new_value)


func get_tip_counter() -> int:
	return _tip_counter


func set_waiting_seconds(new_value: float) -> void:
	_waiting_seconds = new_value


func get_waiting_seconds() -> float:
	return _waiting_seconds


func set_point_counter(new_value: int) -> void:
	_point_counter = new_value


func get_point_counter() -> int:
	return _point_counter


func set_pet_images_state(new_value: Dictionary) -> void:
	_pet_images_state = new_value


func get_pet_images_state() -> Dictionary:
	return _pet_images_state


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	pet_background.set("modulate", API.theme.get_color(API.theme.PL3))


func _load_current_question() -> void:
	pet_image.texture = get_pet_images_state()["idle"]
	
	set_current_question(get_current_question())
	var dictionary_questions: Dictionary = API.game.get_questions()[get_current_question()]
	
	question.text = dictionary_questions["question"]
	
	var random_alternatives: Array = Array([])
	random_alternatives.append(dictionary_questions["alternatives"][0]["correct"])
	if dictionary_questions["alternatives"].size() >= 2:
		random_alternatives.append(dictionary_questions["alternatives"][1]["incorrect"])
	if dictionary_questions["alternatives"].size() >= 3:
		random_alternatives.append(dictionary_questions["alternatives"][2]["incorrect"])
	if dictionary_questions["alternatives"].size() >= 4:
		random_alternatives.append(dictionary_questions["alternatives"][3]["incorrect"])
	
	randomize()
	random_alternatives.shuffle()
	var temp = random_alternatives[0]
	random_alternatives[0] = random_alternatives[random_alternatives.size()-1]
	random_alternatives[random_alternatives.size()-1] = temp
	
	# configure visibility state
	var counter: int = 0
	for alternative in question_container.get_children():
		if alternative is Alternative:
			counter += 1
			alternative.number.text = str(counter)
			alternative.disabled(true)
			alternative.checker_visible(false)
			alternative.set("modulate", Color(1.0, 1.0, 1.0, 1.0))
	
	# set text
	if dictionary_questions["alternatives"].size() >= 1:
		alternative_1.message.text = random_alternatives[0]
		alternative_1.disabled(false)
	else:
		alternative_1.set("modulate", Color(0.0, 0.0, 0.0, 0.0))
		
	if dictionary_questions["alternatives"].size() >= 2:
		alternative_2.message.text = random_alternatives[1]
		alternative_2.disabled(false)
	else:
		alternative_2.set("modulate", Color(0.0, 0.0, 0.0, 0.0))
		
	if dictionary_questions["alternatives"].size() >= 3:
		alternative_3.message.text = random_alternatives[2]
		alternative_3.disabled(false)
	else:
		alternative_3.set("modulate", Color(0.0, 0.0, 0.0, 0.0))
		
	if dictionary_questions["alternatives"].size() >= 4:
		alternative_4.message.text = random_alternatives[3]
		alternative_4.disabled(false)
	else:
		alternative_4.set("modulate", Color(0.0, 0.0, 0.0, 0.0))


func _reveal_alternatives() -> void:
	var dictionary_questions: Dictionary = API.game.get_questions()[get_current_question()]
	var correct_alternative: String = dictionary_questions["alternatives"][0]["correct"]
	
	for alternative in question_container.get_children():
		if alternative is Alternative:
			if alternative.message.text == correct_alternative:
				alternative.checker_visible(true)
				alternative.set_checker_state(true)
			else:
				alternative.checker_visible(true)
				alternative.set_checker_state(false)


func _call_next_question() -> void:
	set_state(State.WAITING)
	yield(get_tree().create_timer(get_waiting_seconds()), "timeout")
	set_state(State.FREE)
	if (get_current_question() + 1) < get_total_questions(): 
		set_current_question(get_current_question() + 1)
		_load_current_question()
	else:
		emit_signal("end_game")
 

#  [SIGNAL_METHODS]
func _on_Home_pressed() -> void:
	get_tree().change_scene("res://home/home.tscn")


func _on_Alternative1_Button_pressed(message: String) -> void:
	alternative_1.disabled(true, true)
	alternative_2.disabled(true)
	alternative_3.disabled(true)
	alternative_4.disabled(true)
	
	var dictionary_questions: Dictionary = API.game.get_questions()[get_current_question()]
	if alternative_1.message.text == dictionary_questions["alternatives"][0]["correct"]:
		set_point_counter(get_point_counter() + 1)
		pet_image.texture = get_pet_images_state()["happy"]
	else:
		pet_image.texture = get_pet_images_state()["loser"]
	
	_reveal_alternatives()
	_call_next_question()
	


func _on_Alternative2_Button_pressed(message: String) -> void:
	alternative_1.disabled(true)
	alternative_2.disabled(true, true)
	alternative_3.disabled(true)
	alternative_4.disabled(true)
	
	var dictionary_questions: Dictionary = API.game.get_questions()[get_current_question()]
	if alternative_2.message.text == dictionary_questions["alternatives"][0]["correct"]:
		set_point_counter(get_point_counter() + 1)
		pet_image.texture = get_pet_images_state()["happy"]
	else:
		pet_image.texture = get_pet_images_state()["loser"]
	
	_reveal_alternatives()
	_call_next_question()


func _on_Alternative3_Button_pressed(message: String) -> void:
	alternative_1.disabled(true)
	alternative_2.disabled(true)
	alternative_3.disabled(true, true)
	alternative_4.disabled(true)
	
	var dictionary_questions: Dictionary = API.game.get_questions()[get_current_question()]
	if alternative_3.message.text == dictionary_questions["alternatives"][0]["correct"]:
		set_point_counter(get_point_counter() + 1)
		pet_image.texture = get_pet_images_state()["happy"]
	else:
		pet_image.texture = get_pet_images_state()["loser"]
	
	_reveal_alternatives()
	_call_next_question()


func _on_Alternative4_Button_pressed(message: String) -> void:
	alternative_1.disabled(true)
	alternative_2.disabled(true)
	alternative_3.disabled(true)
	alternative_4.disabled(true, true)
	
	var dictionary_questions: Dictionary = API.game.get_questions()[get_current_question()]
	if alternative_4.message.text == dictionary_questions["alternatives"][0]["correct"]:
		set_point_counter(get_point_counter() + 1)
		pet_image.texture = get_pet_images_state()["happy"]
	else:
		pet_image.texture = get_pet_images_state()["loser"]
	
	_reveal_alternatives()
	_call_next_question()


func _on_Tip_pressed() -> void:
	if get_state() == State.FREE:
	
		if get_tip_counter() > 0:
			set_tip_counter(get_tip_counter() -1)
		
		if get_tip_counter() == 0:
			tip_counter.visible = false
			tip.disabled = true
		
		var dictionary_questions: Dictionary = API.game.get_questions()[get_current_question()]
		
		var incorrect_alternatives: Array = []
		for alternative in dictionary_questions["alternatives"]:
			if alternative.has("incorrect"):
				incorrect_alternatives.append(alternative["incorrect"])
		
		for alternative in question_container.get_children():
			if alternative is Alternative:
				if alternative.message.text in incorrect_alternatives and not alternative.is_disabled():
					print(alternative.message.text)
					alternative.disabled(true)
					
					break


func _on_Self_end_game() -> void:
	var panel_information: Resource = preload("res://games/quiz/panel_information/panel_information.tscn")
	var panel_information_instance: Panel = panel_information.instance()
	self.add_child(panel_information_instance)
	panel_information_instance.init_panel(get_point_counter(), get_total_questions())
	panel_information_instance.connect("restart_level", self, "_on_PanelInformation_restart_level")
	panel_information_instance.connect("continue_level", self, "_on_PanelInformation_continue_level")


func _on_PanelInformation_restart_level() -> void:
	pass


func _on_PanelInformation_continue_level() -> void:
	pass


func _on_Help_pressed() -> void:
	var how_to_play_instance := HOW_TO_PLAY.instance()
	add_child(how_to_play_instance)
	how_to_play_instance.set_textures(HOW_TO_PLAY_TEXTURES)

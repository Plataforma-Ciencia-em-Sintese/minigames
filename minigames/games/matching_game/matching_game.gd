#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]
signal end_game


#  [ENUMS]
enum GameMode {EASY, MEDIUM, HARD}


#  [CONSTANTS]
const EASY_LEVEL: PackedScene = preload("res://games/matching_game/level/easy_level/easy_level.tscn")
const MEDIUM_LEVEL: PackedScene = preload("res://games/matching_game/level/medium_level/medium_level.tscn")
const HARD_LEVEL: PackedScene = preload("res://games/matching_game/level/hard_level/hard_level.tscn")

const GAME_RESULTS: PackedScene = preload("res://game_results/game_results.tscn")
const HOW_TO_PLAY: PackedScene = preload("res://how_to_play/how_to_play.tscn")
const HOW_TO_PLAY_TEXTURES: Array = Array([
	preload("res://assets/images/htp_matching_game_0.png"),
	preload("res://assets/images/htp_matching_game_1.png"),
	preload("res://assets/images/htp_matching_game_2.png"),
	preload("res://assets/images/htp_matching_game_3.png")
])


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]
#var how_to_play_images: Array = Array([
#	preload("res://assets/images/htp_matching_game_0.png")
#])


#  [PRIVATE_VARIABLES]
var _current_mode: int = GameMode.EASY \
		setget set_current_mode, get_current_mode

var _card_counter_level: int = int(0) \
		setget set_card_counter_level, get_card_counter_level

var _points_counter: int = int(0) \
		setget set_points_counter, get_points_counter

var _attempts_counter: int = int(0) \
		setget set_attempts_counter, get_attempts_counter

var _timer_counter: int = int() \
		setget set_timer_counter, get_timer_counter

var _timer_has_started: bool = false \
		setget set_timer_has_starded, get_timer_has_started


#  [ONREADY_VARIABLES]
onready var level_label: Label = $MarginContainer/VBoxContainer/BarContainer/Container/Level
onready var level_area: Panel = $MarginContainer/VBoxContainer/GameContainer/Panel
onready var timer: Timer = $Timer
onready var timer_label: Label = $MarginContainer/VBoxContainer/BarContainer/Container/Time

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	connect("end_game", self, "_on_MatchingGame_end_game")
	set_current_mode(ChangeLevel.request_mode)


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_current_mode(new_value: int) -> void:
	_current_mode = new_value
	
	for child in level_area.get_children():
		child.queue_free()
	
	var level_instance: MarginContainer = null
	
	match(_current_mode):
		GameMode.EASY:
			level_label.text = "Fácil"
			level_instance = EASY_LEVEL.instance()
			
			
		GameMode.MEDIUM:
			level_label.text = "Médio"
			level_instance = MEDIUM_LEVEL.instance()
			
		GameMode.HARD:
			level_label.text = "Difícil"
			level_instance = HARD_LEVEL.instance()
	
	level_area.add_child(level_instance)
	
	set_card_counter_level(level_instance.CARD_COUNTER)
	
	for slot in level_instance.target_slots:
		slot.get_child(0).connect("was_combined", self, "_on_Target_was_combined")
		slot.get_child(0).connect("attempt_to_combine", self, "_on_Target_attempt_to_combine")


func get_current_mode() -> int:
	return _current_mode


func set_card_counter_level(new_value) -> void:
	_card_counter_level = new_value


func get_card_counter_level() -> int:
	return _card_counter_level


func set_points_counter(new_value: int) -> void:
	_points_counter = new_value


func get_points_counter() -> int:
	return _points_counter


func set_attempts_counter(new_value: int) -> void:
	_attempts_counter = new_value


func get_attempts_counter() -> int:
	return _attempts_counter


func set_timer_counter(new_value: int) -> void:
	_timer_counter = new_value
	var seconds: int = _timer_counter
	
# warning-ignore:integer_division
	timer_label.text = "%02d:%02d" % [(seconds/60) % 60, seconds % 60]


func get_timer_counter() -> int:
	return _timer_counter

func set_timer_has_starded(new_value: bool) -> void:
	_timer_has_started = new_value
	
	match(_timer_has_started):
		true:
			timer.start()
		false:
			timer.stop()


func get_timer_has_started() -> bool:
	return _timer_has_started


#  [PRIVATE_METHODS]
func _reset_counters() -> void:
	set_points_counter(0)
	set_attempts_counter(0)
	set_timer_counter(0)


func _scoring_rules() -> int:
	var target_attempt: int = 0
	var margin_attempt: int = 0
	var target_time: int = 0
	var margin_time: int = 0
	var stars: int = 0
	var stars_check: bool = false
	
	match(get_current_mode()):
		GameMode.EASY:
			target_attempt = 10
			margin_attempt = 5
			target_time = 40
			margin_time = 10
			
		GameMode.MEDIUM:
			target_attempt = 20
			margin_attempt = 5
			target_time = 70
			margin_time = 10
			
		GameMode.HARD:
			target_attempt = 30
			margin_attempt = 5
			target_time = 90
			margin_time = 10
	
	# three stars
	if get_timer_counter() < target_time and get_attempts_counter() < target_attempt:
		if not stars_check:
			stars = 3
			stars_check = true
	
	# two stars
	elif get_timer_counter() < (target_time + margin_time) and get_attempts_counter() < (target_attempt + margin_attempt):
		if not stars_check:
			stars = 2
			stars_check = true
	
	# one stars
	elif (get_timer_counter() < (target_time + margin_time) and get_attempts_counter() > (target_attempt + margin_attempt)) or \
			(get_timer_counter() > (target_time + margin_time) and get_attempts_counter() < (target_attempt + margin_attempt)):
		if not stars_check:
			stars = 1
			stars_check = true
	
	# zero stars
	elif get_timer_counter() > (target_time + margin_time) and get_attempts_counter() > (target_attempt + margin_attempt):
		if not stars_check:
			stars = 0
			stars_check = true
	
	return stars
 

#  [SIGNAL_METHODS]
func _on_Target_was_combined() -> void:
	#print("was combined")
	if get_points_counter() + 1 == get_card_counter_level():
		set_points_counter(get_points_counter() + 1)
		emit_signal("end_game")
		
		set_timer_has_starded(false)
		
	else:
		set_points_counter(get_points_counter() + 1)
		
		if not get_timer_has_started():
			set_timer_has_starded(true)


func _on_Target_attempt_to_combine() -> void:
	print("attempt to combine")
	set_attempts_counter(get_attempts_counter() + 1)
	
	if not get_timer_has_started():
		set_timer_has_starded(true)


func _on_MatchingGame_end_game() -> void:
	var game_results_instance: Panel = GAME_RESULTS.instance()
	add_child(game_results_instance)
	
	var message_game: String = \
			"Você completou o nível!\n" + \
			"Conseguiu [color=#{api_color}][b]{value}[/b][/color] estrelas."
	message_game = message_game.format({
		"api_color": API.theme.get_color(API.theme.PB).to_html(false), 
		"value": _scoring_rules()
	})
	
	var seconds: int = get_timer_counter()
	var message_statistic: String = \
			"Tempo: [color=#{api_color}][b]{time_counter}[/b][/color]" + \
			"\nTentativas: [color=#{api_color}][b]{attempt_counter}[/b][/color]"
	message_statistic = message_statistic.format({
		"api_color": API.theme.get_color(API.theme.PB).to_html(false),
		"time_counter": "%02d:%02d" % [(seconds/60) % 60, seconds % 60],
		"attempt_counter": "%02d" % [get_attempts_counter()]
	})
	
	game_results_instance.update_data(message_game, message_statistic, _scoring_rules(), get_current_mode())
	game_results_instance.connect("restart_level", self, "_on_GameResults_restart_level")
	game_results_instance.connect("continue_level", self, "_on_GameResults_continue_level")


func _on_GameResults_restart_level() -> void:
	_reset_counters()
	set_current_mode(get_current_mode())


func _on_GameResults_continue_level() -> void:
	var targets: int = API.game.get_targets().size()
	var bullets: int = API.game.get_bullets().size()
	match(get_current_mode()):
		GameMode.EASY:
			if (targets + bullets) >= 18 or targets == bullets:
				_reset_counters()
				set_current_mode(GameMode.MEDIUM)
			
		GameMode.MEDIUM:
			if (targets + bullets) >= 32 or targets == bullets:
				_reset_counters()
				set_current_mode(GameMode.HARD)
			
		GameMode.HARD:
			if (targets + bullets) >= 12 or targets == bullets:
				_reset_counters()
				set_current_mode(GameMode.EASY)


func _on_HowToPlay_closed() -> void:
	if get_timer_counter() > 0:
		timer.start()


func _on_Home_pressed() -> void:
	get_tree().change_scene("res://home/home.tscn")


func _on_Help_pressed() -> void:
	timer.stop()
	
	var how_to_play_instance := HOW_TO_PLAY.instance()
	add_child(how_to_play_instance)
	how_to_play_instance.set_textures(HOW_TO_PLAY_TEXTURES)
	how_to_play_instance.connect("closed", self, "_on_HowToPlay_closed")


func _on_Timer_timeout() -> void:
	var seconds: int = get_timer_counter()
	seconds += 1
	set_timer_counter(seconds)

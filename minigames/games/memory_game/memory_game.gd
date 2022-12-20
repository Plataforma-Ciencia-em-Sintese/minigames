#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]
signal add_cards
signal failed_attempt
signal start_timer
signal show_panel_information


#  [ENUMS]
enum GameMode {EASY, MEDIUM, HARD}


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]
var failed_attempt: int = 0
#var panel_information = null


#  [PRIVATE_VARIABLES]
var _cards: Array = Array() \
		setget set_cards, get_cards

var _current_mode: int = GameMode.EASY \
		setget set_current_mode, get_current_mode
var turned_cards: Array = Array()
var _timer_has_started: bool = false \
		setget set_timer_has_starded, get_timer_has_started
var _timer_counter: int = int() \
		setget set_timer_counter, get_timer_counter


#  [ONREADY_VARIABLES]
onready var CardButton := preload("res://games/memory_game/card/card.tscn")
onready var HowToPlay := preload("res://games/memory_game/how_to_play/how_to_play.tscn")
onready var grid := $"MarginContainer/VBoxContainer/GameContainer/MarginContainer/GridContainer"
onready var timer_label := $"MarginContainer/VBoxContainer/BarContainer/Container/Time"
onready var level_label := $"MarginContainer/VBoxContainer/BarContainer/Container/Level"
onready var timer:= $Timer
onready var bar_container := $"MarginContainer/VBoxContainer/BarContainer"
onready var dev_mode = $DevMode
onready var fullscreen = $"MarginContainer/VBoxContainer/BarContainer/FullScreen"
onready var panel_information = $PanelInformation
onready var total_stars = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/CongratulationsContainer/TotalStars
onready var total_time = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/StatisticsContainer/TimeContainer/TotalTime
onready var total_attempts = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/StatisticsContainer/AttemptsContainer/TotalAttempts
onready var show_panel_information := $ShowPanelInformation


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	
	_load_theme()
	
	connect("add_cards", self, "_on_add_cards")
	connect("failed_attempt", self, "_on_failed_attempt")
	connect("start_timer", self, "_on_start_timer")
	connect("show_panel_information", self, "_on_show_PanelInformation")
	
	set_current_mode(ChangeLevel.request_mode)
	
	get_tree().get_root().connect("size_changed", self, "_on_window_size_changed")


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("dev_mode"):
		dev_mode.visible = !dev_mode.visible


#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_cards(new_cards: Array) -> void:
	for card in new_cards:
		_cards.append(card)


func get_cards() -> Array:
	return _cards


func set_current_mode(mode: int) -> void:
	_current_mode = mode
	
	
	get_cards().clear()
	for child in grid.get_children():
		child.queue_free()
	
	match(mode):
		GameMode.EASY:
			level_label.text = "Fácil"
			set_cards(API.game.get_cards())
			_make_grid(get_current_mode())
			show_cards(0.5)

		GameMode.MEDIUM:
			level_label.text = "Médio"
			set_cards(API.game.get_cards())
			_make_grid(get_current_mode())
			show_cards(0.5)
			
		GameMode.HARD:
			level_label.text = "Difícil"
			set_cards(API.game.get_cards())
			_make_grid(get_current_mode())
			show_cards(0.5)


func get_current_mode() -> int:
	return _current_mode


func set_timer_has_starded(new_value: bool) -> void:
	_timer_has_started = new_value


func get_timer_has_started() -> bool:
	return _timer_has_started


func set_timer_counter(new_value: int) -> void:
	_timer_counter = new_value


func get_timer_counter() -> int:
	return _timer_counter


#func random_number(start: int, end: int) -> int:
#	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
#	rng.randomize()
#	return rng.randi_range(start, end)


func random_card() -> Dictionary:
	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.randomize()
	
	var random_index: int = random.randi_range(0, get_cards().size() -1)

	var result: Dictionary = get_cards()[random_index]
	get_cards().remove(random_index)
	
	return result # {subtitle: String, texture: ImageTexture}


func shuffle_cards() -> void:
	var steps: int = 2
	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	
	for _i in range(0, steps):
		for card in grid.get_children():
			var temporary_position: Vector2 = Vector2(0.0, 0.0)
			
			#var ramdom_card := grid.get_child(random_number(0, grid.get_children().size()-1))
			randomize()
			random.randomize()
			var ramdom_card := grid.get_child(random.randi_range(0, grid.get_children().size()-1))
			
			temporary_position = card.get_position()
			card.set_position(ramdom_card.get_position())
			ramdom_card.set_position(temporary_position)
			
			var temporary_index: int = card.get_position_in_parent()
			grid.move_child(card, ramdom_card.get_position_in_parent())
			grid.move_child(ramdom_card, temporary_index)


func show_cards(time: float) -> void:
	yield(get_tree().create_timer(time), "timeout")
	for card in grid.get_children():
		if card.get_state() == card.State.FRONT:
			card.turn_animation()

#  [PRIVATE_METHODS]
func _load_theme() -> void:
	timer_label.set("custom_colors/font_color", API.theme.get_color(API.theme.PD1))
	var state_normal: StyleBoxFlat = timer_label.get("custom_styles/normal")
	state_normal.set("border_color", API.theme.get_color(API.theme.PD1))


func _make_grid(mode: int):
	var total_cards: int = 0
	var card_size: Vector2 = Vector2.ZERO
	
	match(mode):
		GameMode.EASY:
			grid.columns = 4
			total_cards = 12
			card_size = Vector2(280, 280) #Vector2(256, 256)
		GameMode.MEDIUM:
			grid.columns = 5
			total_cards = 20
			card_size = Vector2(208, 208) #Vector2(200, 200)
		GameMode.HARD:
			grid.columns = 6
			total_cards = 24
			card_size = Vector2(208, 208) #Vector2(180, 180)
	
# warning-ignore:integer_division
	for i in range(0, (total_cards/2)): # number of cards divided by 2 insertions
		
		var card: Dictionary = random_card()
#		for child in grid.get_children():
#			if card.has("subtitle"):
#				if child.get_subtitle() == card["subtitle"]:
#					return
		
		for _j in range(0, 2):
			var new_card := CardButton.instance()
			grid.add_child(new_card)
			new_card.rect_min_size = card_size
			new_card.set_id(i)
			if card.has("image"):
				new_card.set_front_image(card["image"])
			if card.has("subtitle"):	
				new_card.set_subtitle(card["subtitle"])
			new_card.connect("card_turned", self, "_on_card_turned")
			
	emit_signal("add_cards")


func _reset_counters() -> void:
	timer.stop()
	set_timer_has_starded(false)
	set_timer_counter(0)
	yield(get_tree().create_timer(1.0), "timeout") # temporary until set theme template
	timer_label.text = "00:00"
	failed_attempt = 0


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
	if get_timer_counter() < target_time and failed_attempt < target_attempt:
		if not stars_check:
			stars = 3
			stars_check = true
	
	# two stars
	elif get_timer_counter() < (target_time + margin_time) and failed_attempt < (target_attempt + margin_attempt):
		if not stars_check:
			stars = 2
			stars_check = true
	
	# one stars
	elif (get_timer_counter() < (target_time + margin_time) and failed_attempt > (target_attempt + margin_attempt)) or \
			(get_timer_counter() > (target_time + margin_time) and failed_attempt < (target_attempt + margin_attempt)):
		if not stars_check:
			stars = 1
			stars_check = true
	
	# zero stars
	elif get_timer_counter() > (target_time + margin_time) and failed_attempt > (target_attempt + margin_attempt):
		if not stars_check:
			stars = 0
			stars_check = true
	
	var first_star: Label = panel_information.get_node("GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/RecordContainer/Stars/First")
	var second_star: Label = panel_information.get_node("GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/RecordContainer/Stars/Second")
	var third_star: Label = panel_information.get_node("GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/RecordContainer/Stars/Third")
	match(stars):
		0:
			first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
			second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
			third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
		1:
			first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
			third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
		2:
			first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
		3:
			first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
	
	return stars


func _update_panel_information() -> void:
	var color_bbtext: String = str(API.theme.get_color(API.theme.PB).to_html(false))
	total_stars.bbcode_text = str("Você completou o nível!\nConseguiu [color=#" + color_bbtext + "][b]" + str(_scoring_rules()) + "[/b][/color] estrelas.")
	total_time.text = timer_label.text
	total_attempts.text = str(failed_attempt)


#  [SIGNAL_METHODS]
func _on_window_size_changed() -> void:
	dev_mode.visible = false


func _on_add_cards() -> void:
	shuffle_cards()


func _on_card_turned(card_instance) -> void:
	emit_signal("start_timer")
	#var restart_button: Button = $MarginContainer/VBoxContainer/BarContainer/Restart
	
	if turned_cards.size() == 0:
		turned_cards.append(card_instance)
		#restart_button.disabled = true
		
		return
	if turned_cards.size() == 1:
		for card in grid.get_children():
			card.disabled = true
			card.back_color.disabled = true
			#if card.get_state() == card.State.BACK:
				#card.lock_card_label.visible = true
		yield(get_tree().create_timer(1.0), "timeout")
		if turned_cards[0].get_id() == card_instance.get_id():
			card_instance.set_state(card_instance.State.COMPLETED)
			turned_cards[0].set_state(turned_cards[0].State.COMPLETED)
			turned_cards.clear()
			#restart_button.disabled = false
		else:
			card_instance.turn_animation()
			turned_cards[0].turn_animation()
			yield(turned_cards[0], "turnning_completed")
			card_instance.disabled = false
			card_instance.back_color.disabled = false
			#card_instance.lock_card_label.visible = false
			turned_cards[0].disabled = false
			turned_cards[0].back_color.disabled = false
			#turned_cards[0].lock_card_label.visible = false
			
			turned_cards.clear()
			#restart_button.disabled = false
			emit_signal("failed_attempt")
			
		for card in grid.get_children():
			if card.get_state() == card.State.BACK:
				card.disabled = false
				card.back_color.disabled = false
				#card.lock_card_label.visible = false

	is_full_level()


func _on_start_timer() -> void:
	if not get_timer_has_started():
		set_timer_has_starded(true)
		timer.start()


func _on_failed_attempt() -> void:
	failed_attempt += 1


func is_full_level() -> void:
	var remaining_pairs_counter: int = 0
	
	for card in grid.get_children():
			if not card.get_state() == card.State.COMPLETED:
				remaining_pairs_counter += 1
	
	if remaining_pairs_counter == 0:
		yield(get_tree().create_timer(1.0), "timeout")
		emit_signal("show_panel_information")


func _on_Restart_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_cards(Array())
		set_current_mode(get_current_mode())


func _on_Timer_timeout() -> void:
	var seconds: int = get_timer_counter()
	seconds += 1
	set_timer_counter(seconds)
	
# warning-ignore:integer_division
# warning-ignore:integer_division
# warning-ignore:integer_division
	timer_label.text = "%02d:%02d" % [(seconds/60) % 60, seconds % 60]


func _on_Home_pressed() -> void:
	get_tree().change_scene("res://home/home.tscn")


func _on_DevLevel1_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_current_mode(GameMode.EASY)


func _on_DevLevel2_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_current_mode(GameMode.MEDIUM)


func _on_DevLevel3_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_current_mode(GameMode.HARD)


func _on_show_PanelInformation() -> void:
	timer.stop()
	_update_panel_information()
	panel_information.visible = true


func _on_PanelInformation_Restart_pressed() -> void:
	panel_information.visible = false
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_cards(Array())
		set_current_mode(get_current_mode())


func _on_PanelInformation_Skip_pressed() -> void:
	_reset_counters()
	
	match(get_current_mode()):
		GameMode.EASY:
			set_current_mode(GameMode.MEDIUM)
		GameMode.MEDIUM:
			set_current_mode(GameMode.HARD)
		GameMode.HARD:
			set_current_mode(GameMode.EASY)
	
	panel_information.visible = false


func _on_Hide_pressed() -> void:
	for child in bar_container.get_children():
		if child is Button:
			child.disabled = true
			
	panel_information.visible = false
	show_panel_information.visible = true


func _on_ShowPanelInformation_pressed() -> void:
	for child in bar_container.get_children():
		if child is Button:
			child.disabled = false
	show_panel_information.visible = false
	panel_information.visible = true


func _on_Help_pressed() -> void:
	timer.stop()
	var how_to_play := HowToPlay.instance()
	add_child(how_to_play)
	how_to_play.connect("close", self, "_on_HowToPlay_close")


func _on_HowToPlay_close() -> void:
	if get_timer_counter() > 0:
		timer.start()

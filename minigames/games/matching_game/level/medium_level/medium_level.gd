#tool
#class_name Name #, res://class_name_icon.svg
extends MarginContainer


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]
const TARGET: PackedScene = preload("res://games/matching_game/target/target.tscn")
const BULLET: PackedScene = preload("res://games/matching_game/bullet/bullet.tscn")
const CARD_COUNTER: int = int(9) 


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]
onready var target_panel: PanelContainer = $MainContainer/HBoxContainer/Targets/Panel
onready var bullet_panels: Array = Array([
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer1/Panel,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer2/Panel,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer3/Panel,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer4/Panel,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer5/Panel,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer6/Panel,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer7/Panel,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer8/Panel,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer9/Panel
])

onready var target_slots: Array = Array([
	$MainContainer/HBoxContainer/Targets/Panel/MarginContainer/GridContainer/AspectRatioContainer1/Slot1,
	$MainContainer/HBoxContainer/Targets/Panel/MarginContainer/GridContainer/AspectRatioContainer2/Slot2,
	$MainContainer/HBoxContainer/Targets/Panel/MarginContainer/GridContainer/AspectRatioContainer3/Slot3,
	$MainContainer/HBoxContainer/Targets/Panel/MarginContainer/GridContainer/AspectRatioContainer4/Slot4,
	$MainContainer/HBoxContainer/Targets/Panel/MarginContainer/GridContainer/AspectRatioContainer5/Slot5,
	$MainContainer/HBoxContainer/Targets/Panel/MarginContainer/GridContainer/AspectRatioContainer6/Slot6,
	$MainContainer/HBoxContainer/Targets/Panel/MarginContainer/GridContainer/AspectRatioContainer7/Slot7,
	$MainContainer/HBoxContainer/Targets/Panel/MarginContainer/GridContainer/AspectRatioContainer8/Slot8,
	$MainContainer/HBoxContainer/Targets/Panel/MarginContainer/GridContainer/AspectRatioContainer9/Slot9
])

onready var bullet_slots: Array = Array([
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer1/Panel/Slot1,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer2/Panel/Slot2,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer3/Panel/Slot3,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer4/Panel/Slot4,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer5/Panel/Slot5,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer6/Panel/Slot6,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer7/Panel/Slot7,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer8/Panel/Slot8,
	$MainContainer/HBoxContainer/Bullets/GridContainer/AspectRatioContainer9/Panel/Slot9
])


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()
	_load_cards()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	var panel_style: StyleBoxFlat = target_panel.get("custom_styles/panel")
	panel_style.set("bg_color", API.theme.get_color(API.theme.PB))

	for panel in bullet_panels:
		panel_style = panel.get("custom_styles/panel")
		panel_style.set("bg_color", API.theme.get_color(API.theme.PB))


func _load_cards() -> void:
	var api_targets: Array = API.game.get_targets()
	var api_bullets: Array = API.game.get_bullets()
	var random_bullets: Array = Array([])
	
	randomize()
	api_targets.shuffle()
	
	var index: int = 0
	if api_targets.size() >= CARD_COUNTER and api_bullets.size() >= CARD_COUNTER:
		for slot in target_slots:
			var target_instance := TARGET.instance()
			slot.add_child(target_instance)
			target_instance.create(
				api_targets[index]["image"], 
				api_targets[index]["matching_id"], 
				api_targets[index]["subtitle"]
			)
			
			for bullet in api_bullets:
				if bullet["matching_id"] == api_targets[index]["matching_id"]:
					random_bullets.append(bullet)
			
			index += 1
		
		randomize()
		random_bullets.shuffle()
		index = 0
		for slot in bullet_slots:
			var bullet_instance := BULLET.instance()
			bullet_slots[index].add_child(bullet_instance)
			bullet_instance.create(
				random_bullets[index]["image"], 
				random_bullets[index]["matching_id"], 
				random_bullets[index]["subtitle"]
			)
			index += 1


#  [SIGNAL_METHODS]

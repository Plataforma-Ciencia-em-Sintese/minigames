extends ScrollContainer


const _TipListItem: PackedScene = preload("res://games/wordhunt/tip_list_item/tip_list_item.tscn")


onready var _list: VBoxContainer = $"%List"


func get_list() -> VBoxContainer:
	return _list


func _ready() -> void:
	insert_tips_into_tip_list(API.game.get_words())


func insert_tips_into_tip_list(tips: Dictionary) -> void:
	_delete_all_childs(_list)
	for i in range(0, tips.size()):
		var new_tip: MarginContainer = _TipListItem.instance()
		_list.add_child(new_tip)
		new_tip.set_word(str(tips.keys()[i]))
		new_tip.set_tip_text(str(tips.values()[i]))


func _delete_all_childs(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

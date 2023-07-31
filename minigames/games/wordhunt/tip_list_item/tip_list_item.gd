extends MarginContainer


enum State {
	NOT_SOLVED = 0,
	SOLVED = 1,
}


var _word: String = ""
var _tip_without_bbcode: String = ""
var _state: int = State.NOT_SOLVED


onready var _tip: RichTextLabel = $"%Tip"


func get_state() -> int:
	return _state


func set_word(new_value: String) -> void:
	_word = new_value


func get_word() -> String:
	return _word


func get_expected_word() -> String:
	var expected_word: String = _word
	expected_word = StringHandler.remove_accent(expected_word)
	expected_word = StringHandler.removes_special_characters(expected_word)
	return expected_word.to_upper()


func get_word_bbcode() -> String:
	return "[b]%s[/b]" % _word.to_upper()


func set_tip_text(new_value: String) -> void:
	_tip_without_bbcode = new_value
	_tip.set_bbcode(new_value.replace("@", get_word_bbcode()))


func get_tip_text() -> String:
	return _tip.get_bbcode()


func define_tip_solved() -> void:
	_state = State.SOLVED

	var new_bbcode: String = String((
		"[s][color=#{color}]{text}[/color][/s]"
	).format({
		"color": API.theme.get_color(API.theme.PB).to_html(false),
		"text": _tip.get_bbcode(),
	}))

	_tip.set_bbcode(new_bbcode)



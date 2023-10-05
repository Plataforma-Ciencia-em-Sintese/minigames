#tool
class_name RequestWordhuntOmeka #, res://class_name_icon.svg
extends RequestWordhunt


#  [DOCSTRING]


#  [SIGNALS]
signal request_main_completed
signal request_words_completed


#  [ENUMS]


#  [CONSTANTS]
const RESOURCE_MODEL_ID: int = 33
const URL_BASE := "https://repositorio.canalciencia.ibict.br/api/items/"

#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _resources: Dictionary = Dictionary() \
		setget set_resources, get_resources


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_request_main()
	_request_words()



	yield(self, "request_words_completed")
	# called upon completion of all requests
	emit_signal("all_request_game_completed")

	# clear the result of the main request
	set_resources(Dictionary())


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_resources(new_value: Dictionary) -> void:
	_resources = new_value


func get_resources() -> Dictionary:
	return _resources


#  [PRIVATE_METHODS]
func _request_main() -> void:
	var url_parameters := URL.get_parameters(URL.TEST_URL)
	if url_parameters.has("id"):
		var http_request: HTTPRequest = HTTPRequest.new()
		add_child(http_request)
		http_request.connect("request_completed", self, "_on_request_main")
		request(http_request, URL_BASE + str(url_parameters["id"]))
	else:
		emit_signal("request_error", "RequestGameOmeka._request_main(): property not found")


func _request_words() -> void:
	yield(self, "request_main_completed")
	if get_resources().has("game:contains"):
		for values in get_resources()["game:contains"]:
			if values.has("@value"):
				if "|" in str(values["@value"]):
					var key: String = values["@value"].split("|")[0]
					var value: String = values["@value"].split("|")[1]
					get_words()[key] = value
				else:
					emit_signal("request_error", "RequestGameOmeka._request_words(): expected 'key|value'")
			else:
				emit_signal("request_error", "RequestGameOmeka._request_words(): property not found")
		emit_signal("request_words_completed")
	else:
		emit_signal("request_error", "RequestGameOmeka._request_words(): property not found")


#  [SIGNAL_METHODS]
func _on_request_main(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))

		match(typeof(json.result)):
			TYPE_DICTIONARY:

				if API.common.get_resource_id() == RESOURCE_MODEL_ID:
					if json.result.has("o:resource_template"):
							set_resources(json.result)
							emit_signal("request_main_completed")
					else:
						emit_signal("request_error", "RequestGameOmeka._on_request_main(): property not found")
				else:
					emit_signal("request_error", "RequestGameOmeka._on_request_main(): The resource model ID does not match as expected")

			_:
				emit_signal("request_error", "RequestGameOmeka._on_request_main(): Unexpected results from JSON response")

	else:
		emit_signal("request_error", str("RequestGameOmeka._on_request_main(): response code return error: ", response_code))

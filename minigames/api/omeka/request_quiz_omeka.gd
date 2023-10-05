#tool
class_name RequestQuizOmeka #, res://class_name_icon.svg
extends RequestQuiz


#  [DOCSTRING]


#  [SIGNALS]
signal request_main_completed
signal request_questions_completed


#  [ENUMS]


#  [CONSTANTS]
const RESOURCE_MODEL_ID: int = 24



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
#	print("RequestGameOmeka call _ready()")
	_request_main()
	_request_questions()

	yield(self, "request_questions_completed")
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


func _request_questions() -> void:
	yield(self, "request_main_completed")
#	for question in get_resources()["bibo:content"]:
#		print(question["display_title"])

	var question_counter: int = int(get_resources()["bibo:content"].size())
#	prints("\n\nPERGUNTAS: ", question_counter)

	for question in get_resources()["bibo:content"]:
		var http_request: HTTPRequest = HTTPRequest.new()
		add_child(http_request)
		http_request.connect("request_completed", self, "_on_request_questions", [question_counter])
		request(http_request, question["@id"])


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


func _on_request_questions(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, question_counter: int) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))

#		print("--------------------------------------------")

		var new_question: Dictionary = Dictionary({})

		if json.result.has("dcterms:title"):
			new_question = {
				"question": str(json.result["dcterms:title"][0]["@value"]),
				"alternatives": []
			}
#			prints("PERGUNTA: ", new_question["question"])

		if json.result.has("dcterms:description"):
			new_question["alternatives"].append((
				{
					"correct": str(json.result["dcterms:description"][0]["@value"]),
					"image_url": ""
				}
			))
#			prints("CORRETA: ", new_question["alternatives"][0]["correct"])


		if json.result.has("bibo:content"):
			var counter: int = 0
			for alternative in json.result["bibo:content"]:
				if alternative.has("@value"):
					counter += 1
					new_question["alternatives"].append((
						{
							"incorrect": str(alternative["@value"]),
							"image_url": ""
						}
					))
#					prints("INCORRETA: ", new_question["alternatives"][counter]["incorrect"])



		# write on _questions
		#print(str(JSON.print(new_question, "\t")))
		get_questions().append(new_question)

		question_counter -= 1
		if get_questions().size() == question_counter:
			emit_signal("request_questions_completed")

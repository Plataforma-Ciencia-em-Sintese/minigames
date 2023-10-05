#tool
class_name RequestMemoryGameOmeka #, res://class_name_icon.svg
extends RequestMemoryGame


#  [DOCSTRING]


#  [SIGNALS]
signal request_main_completed
signal request_cards_completed


#  [ENUMS]


#  [CONSTANTS]
const RESOURCE_MODEL_ID: int = 19
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
	_request_cards()

	yield(self, "request_cards_completed")
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


func _request_cards() -> void:
	yield(self, "request_main_completed")

	if get_resources().has("game:contains"):

		var request_counter = int(get_resources()["game:contains"].size())

		for item in get_resources()["game:contains"]:
			var http_request: HTTPRequest = HTTPRequest.new()
			add_child(http_request)
			http_request.connect("request_completed", self, "_on_request_cards_step1", [request_counter])
			request(http_request, str(item["@id"]))

	else:
		emit_signal("request_error", "RequestGameOmeka._request_cards(): property not found")


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


func _on_request_cards_step1(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, request_counter: int) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))

		match(typeof(json.result)):
			TYPE_DICTIONARY:


				# get cards subtitle
				var subtitle: String = String()
				if json.result.has("bibo:shortDescription"):
					if json.result["bibo:shortDescription"][0].has("@value"):
						subtitle = str(json.result["bibo:shortDescription"][0]["@value"])
					else:
						push_warning("RequestGameOmeka._on_request_cards_step1(): card subtitle, property not found")
				else:
					push_warning("RequestGameOmeka._on_request_cards_step1(): card subtitle, property not found")


				var use_original_media: bool = false
				var image_type: String = String()
				if use_original_media == true:
					if json.result.has("o:media_type"): # EX. "image/png"
						image_type = str(json.result["o:media_type"]).split("/")[1]
					else:
						emit_signal("request_error", "RequestGameOmeka._on_request_cards_step1(): image format not found")

					if json.result.has("o:original_url"):
						var http_request: HTTPRequest = HTTPRequest.new()
						add_child(http_request)
						http_request.connect("request_completed", self, "_on_request_cards_final", [request_counter, subtitle, image_type], 1)
						request(http_request, str(json.result["o:original_url"]))
					else:
						emit_signal("request_error", "RequestGameOmeka._on_request_cards_step1(): card image-url, property not found")

				elif use_original_media == false:
					image_type = "jpg"

					if json.result.has("o:thumbnail_urls"):
						var http_request: HTTPRequest = HTTPRequest.new()
						add_child(http_request)
						http_request.connect("request_completed", self, "_on_request_cards_final", [request_counter, subtitle, image_type], 1)
						request(http_request, str(json.result["o:thumbnail_urls"]["large"]))
					else:
						emit_signal("request_error", "RequestGameOmeka._on_request_cards_step1(): card image-url, property not found")

			_:
				emit_signal("request_error", "RequestGameOmeka._on_request_cards_step1(): Unexpected results from JSON response")

	else:
		emit_signal("request_error", str("RequestGameOmeka._on_request_cards_step1(): response code return error: ", response_code))


func _on_request_cards_final(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, request_counter: int, subtitle: String, image_type: String) -> void:
	if response_code == 200:

		var image: Image = Image.new()
		var error: int = 0
		match(image_type.to_upper()):
			"JPG", "JPEG":
				error = image.load_jpg_from_buffer(body)
			"PNG":
				error = image.load_png_from_buffer(body)
			"WEBP":
				error = image.load_webp_from_buffer(body)
			"BMP":
				error = image.load_bmp_from_buffer(body)
			"TGA":
				error = image.load_tga_from_buffer(body)

		if error != OK:
			emit_signal("request_error", "RequestGameOmeka._on_request_cards_final): image format is not supported")

		var image_texture: ImageTexture = ImageTexture.new()
		image_texture.create_from_image(image)

		var cards: Array = get_cards()
		cards.append({"image": image_texture, "subtitle": subtitle})
		set_cards(cards)

		if get_cards().size() == request_counter:
			emit_signal("request_cards_completed")

	else:
		emit_signal("request_error", str("RequestCommonOmeka._on_request_game_logo_final(): response code return error: ", response_code))

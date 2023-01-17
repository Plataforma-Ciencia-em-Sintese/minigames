#tool
class_name RequestMatchingGameOmeka #, res://class_name_icon.svg
extends RequestMatchingGame


#  [DOCSTRING]


#  [SIGNALS]
signal request_main_completed
signal request_cards_completed


#  [ENUMS]


#  [CONSTANTS]
const RESOURCE_MODEL_ID: int = 29
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
	print("RequestGameOmeka call _ready()")
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
		var matching_id = 0
		var card_type ="target"
		#for item in get_resources()["game:contains"]:
		for index in int(get_resources()["game:contains"].size()):			
			#itera sobre as imagens intercalando como target e bullet
			var item = get_resources()["game:contains"][index]
			var http_request: HTTPRequest = HTTPRequest.new()
			if index %2 == 0:
				matching_id = index
				card_type ="target"
			else:
				matching_id = index -1
				card_type ="bullet"
				
			add_child(http_request)
			http_request.connect("request_completed", self, "_on_request_cards_step1", [request_counter, matching_id, card_type])
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
				
				set_resources(json.result)
				emit_signal("request_main_completed")
				
				
#				if json.result.has("o:resource_template"):
#					if int(json.result["o:resource_template"]["o:id"]) in [list_ids]:
#						""" IDS VALIDATION"""
						
#					else:
#						emit_signal("request_error", "RequestCommonOmeka._on_request_main(): The resource model ID is valid but does not match as expected")
#				else:
#					emit_signal("request_error", "RequestCommonOmeka._on_request_main(): property not found")
				
			_:
				emit_signal("request_error", "RequestGameOmeka._on_request_main(): Unexpected results from JSON response")
		
	else:
		emit_signal("request_error", str("RequestGameOmeka._on_request_main(): response code return error: ", response_code))


func _on_request_cards_step1(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, request_counter: int, matching_id:int, card_type : String) -> void:
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
						http_request.connect("request_completed", self, "_on_request_cards_final", [request_counter, subtitle, image_type, matching_id, card_type], 1)
						request(http_request, str(json.result["o:original_url"]))
					else:
						emit_signal("request_error", "RequestGameOmeka._on_request_cards_step1(): card image-url, property not found")
				
				elif use_original_media == false:
					image_type = "jpg"
				
					if json.result.has("o:thumbnail_urls"):
						var http_request: HTTPRequest = HTTPRequest.new()
						add_child(http_request)
						http_request.connect("request_completed", self, "_on_request_cards_final", [request_counter, subtitle, image_type, matching_id, card_type], 1)
						request(http_request, str(json.result["o:thumbnail_urls"]["large"]))
					else:
						emit_signal("request_error", "RequestGameOmeka._on_request_cards_step1(): card image-url, property not found")
				
			_:
				emit_signal("request_error", "RequestGameOmeka._on_request_cards_step1(): Unexpected results from JSON response")
		
	else:
		emit_signal("request_error", str("RequestGameOmeka._on_request_cards_step1(): response code return error: ", response_code))


func _on_request_cards_final(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, request_counter: int, subtitle: String, image_type: String, matching_id : int, card_type: String) -> void:
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
			emit_signal("request_error", "RequestGameOmeka._on_request_cards_final(): image format is not supported")
		
		var image_texture: ImageTexture = ImageTexture.new()
		image_texture.create_from_image(image)
		
		if card_type == "bullet" :			
			var bullets: Array = get_bullets()
			bullets.append({"image": image_texture, "subtitle": subtitle, "matching_id": matching_id})
			set_bullets(bullets)	
			#print("definindo bullets" + str(matching_id))
			
		else:
			var targets: Array = get_targets()
			targets.append({"image": image_texture, "subtitle": subtitle, "matching_id": matching_id})
			set_targets(targets)			
			#print("definindo targets" + str(matching_id))	

		if (get_targets().size() + get_bullets().size()) == request_counter:
			emit_signal("request_cards_completed")
			
			
	else:
		emit_signal("request_error", str("RequestCommonOmeka._on_request_cards_final(): response code return error: ", response_code))

#tool
class_name RequestCommonOmeka #, res://class_name_icon.svg
extends RequestCommon


#  [DOCSTRING]


#  [SIGNALS]
signal request_main_completed
signal request_short_title_completed
signal request_article_summary_completed
signal request_game_logo_completed
signal request_article_link_completed
signal request_content_credits_completed
signal request_mascot_completed
signal request_pet_completed


#  [ENUMS]


#  [CONSTANTS]
const RESOURCE_MODEL_ID: int = 20
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
	print("RequestCommonOmeka call _ready()")
	_request_main()
	_request_short_title()
	_request_article_summary()
	_request_game_logo()
	_request_article_link()
	_request_content_credits()
	_request_mascot()
	_request_pet()
	
	
	yield(self, "request_pet_completed")
	# called upon completion of all requests
	emit_signal("all_request_common_completed")
	
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
	var url_parameters := URL.get_parameters("https://.../?id=25308&skip=0")
	if url_parameters.has("id"):
		var http_request: HTTPRequest = HTTPRequest.new()
		add_child(http_request)
		http_request.connect("request_completed", self, "_on_request_main")
		request(http_request, URL_BASE + str(url_parameters["id"]))
	else:
		emit_signal("request_error", "RequestCommonOmeka._request_main(): property not found")


func _request_short_title() -> void:
	yield(self, "request_main_completed")
	
	if get_resources().has("bibo:shortTitle"):
		set_short_title(str(get_resources()["bibo:shortTitle"][0]["@value"]))
		emit_signal("request_short_title_completed")
	else:
		emit_signal("request_error", "RequestCommonOmeka._request_short_title(): property not found")


func _request_article_summary() -> void:
	yield(self, "request_short_title_completed")
	
	if get_resources().has("lom:description"):
		set_article_summary(str(get_resources()["lom:description"][0]["@value"]))
	else:
		push_warning("RequestCommonOmeka._request_article_summary(): property not found")
	
	emit_signal("request_article_summary_completed")


func _request_game_logo() -> void:
	yield(self, "request_article_summary_completed")
	
	if get_resources().has("foaf:img"):
		var http_request: HTTPRequest = HTTPRequest.new()
		add_child(http_request)
		http_request.connect("request_completed", self, "_on_request_game_logo_step1")
		request(http_request, str(get_resources()["foaf:img"][0]["@id"]))
	else:
		push_warning("RequestCommonOmeka._request_game_logo(): property not found")
		emit_signal("request_game_logo_completed")
 

func _request_article_link() -> void:
	yield(self, "request_game_logo_completed")
	
	if get_resources().has("dcterms:isPartOf"):
		if get_resources()["dcterms:isPartOf"][0].has("url"):
			var url = get_resources()["dcterms:isPartOf"][0]["url"]
			if url is String and url.begins_with("url"):
					set_article_link(url)
			else:
				push_warning("RequestCommonOmeka._request_article_link(): the url is not valid")
		else:
			push_warning("RequestCommonOmeka._request_article_link(): the url is not valid")
	else:
		push_warning("RequestCommonOmeka._request_article_link(): property not found")
	
	emit_signal("request_article_link_completed")


func _request_content_credits() -> void:
	yield(self, "request_article_link_completed")
	
	if get_resources().has("bibframe:credits"):
		if get_resources()["bibframe:credits"][0].has("@value"):
			set_content_credits(str(get_resources()["bibframe:credits"][0]["@value"]))
		else:
			push_warning("RequestCommonOmeka._request_content_credits(): property not found")
	else:
		push_warning("RequestCommonOmeka._request_content_credits(): property not found")
	
	emit_signal("request_content_credits_completed")


func _request_mascot() -> void:
	yield(self, "request_content_credits_completed")
#	emit_signal("request_mascot_completed")
	
	if get_resources().has("bibframe:digitalCharacteristic"):
		if get_resources()["bibframe:digitalCharacteristic"][0].has("@id"):
			var http_request: HTTPRequest = HTTPRequest.new()
			add_child(http_request)
			http_request.connect("request_completed", self, "_on_request_mascot_step1")
			request(http_request, str(get_resources()["bibframe:digitalCharacteristic"][0]["@id"]))

		else:
			emit_signal("request_error", "RequestCommonOmeka._request_mascot(): property not found")
	else:
		emit_signal("request_error", "RequestCommonOmeka._request_mascot(): property not found")


func _request_pet() -> void:
	yield(self, "request_mascot_completed")
	
#	emit_signal("request_pet_completed")
	
	if get_resources().has("sioc:avatar"):
		if get_resources()["sioc:avatar"][0].has("@id"):
			var http_request: HTTPRequest = HTTPRequest.new()
			add_child(http_request)
			http_request.connect("request_completed", self, "_on_request_pet_step1")
			request(http_request, str(get_resources()["sioc:avatar"][0]["@id"]))

		else:
			emit_signal("request_error", "RequestCommonOmeka._request_pet(): property not found")
	else:
		emit_signal("request_error", "RequestCommonOmeka._request_pet(): property not found")


#  [SIGNAL_METHODS]
func _on_request_main(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))
		
		match(typeof(json.result)):
			TYPE_DICTIONARY:
				
				if json.result.has("o:resource_template"):
					if int(json.result["o:resource_template"]["o:id"]) == RESOURCE_MODEL_ID:
						set_resources(json.result)
						emit_signal("request_main_completed")
					else:
						emit_signal("request_error", "RequestCommonOmeka._on_request_main(): The resource model ID is valid but does not match as expected")
				else:
					emit_signal("request_error", "RequestCommonOmeka._on_request_main(): property not found")
				
			_:
				emit_signal("request_error", "RequestCommonOmeka._on_request_main(): Unexpected results from JSON response")
		
	else:
		emit_signal("request_error", str("RequestCommonOmeka._on_request_main(): response code return error: ", response_code))


func _on_request_game_logo_step1(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))
		
		match(typeof(json.result)):
			TYPE_DICTIONARY:
				
				var image_type: String = String()
				if json.result.has("o:media_type"): # EX. "image/png"
					image_type = str(json.result["o:media_type"]).split("/")[1]
				else:
					push_warning("RequestCommonOmeka._on_request_game_logo_step1(): image format not found")
					
				if json.result.has("o:original_url"):
					var http_request: HTTPRequest = HTTPRequest.new()
					add_child(http_request)
					http_request.connect("request_completed", self, "_on_request_game_logo_final", [image_type])
					request(http_request, str(json.result["o:original_url"]))
				else:
					push_warning("RequestCommonOmeka._on_request_game_logo_step1(): property not found")
			
			_:
				push_warning("RequestCommonOmeka._on_request_game_logo_step1(): Unexpected results from JSON response")
		
	else:
		push_warning(str("RequestCommonOmeka._on_request_game_logo_step1(): response code return error: ", response_code))


func _on_request_game_logo_final(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, image_type: String) -> void:
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
			push_warning("RequestCommonOmeka._on_request_game_logo_final(): image format is not supported")
		
		var image_texture: ImageTexture = ImageTexture.new()
		image_texture.create_from_image(image)
		set_game_logo(image_texture)
		emit_signal("request_game_logo_completed")
		
	else:
		push_warning(str("RequestCommonOmeka._on_request_game_logo_final(): response code return error: ", response_code))


func _on_request_mascot_step1(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))
		
		match(typeof(json.result)):
			TYPE_DICTIONARY:
					
				if json.result.has("foaf:img"):
					if json.result["foaf:img"][0].has("@id"):
						var http_request: HTTPRequest = HTTPRequest.new()
						add_child(http_request)
						http_request.connect("request_completed", self, "_on_request_mascot_step2")
						request(http_request, str(json.result["foaf:img"][0]["@id"]))
					
					else:
						emit_signal("request_error", "RequestCommonOmeka._on_request_mascot_step1(): property not found")
				else:
					emit_signal("request_error", "RequestCommonOmeka._on_request_mascot_step1(): property not found")
			
			_:
				push_warning("RequestCommonOmeka._on_request_mascot_step1(): Unexpected results from JSON response")
		
	else:
		push_warning(str("RequestCommonOmeka._on_request_mascot_step1(): response code return error: ", response_code))


func _on_request_mascot_step2(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))
		
		match(typeof(json.result)):
			TYPE_DICTIONARY:
				
				var image_type: String = String()
				if json.result.has("o:media_type"): # EX. "image/png"
					image_type = str(json.result["o:media_type"]).split("/")[1]
				else:
					emit_signal("request_error", "RequestCommonOmeka._on_request_mascot_step2(): image format not found")
					
				if json.result.has("o:original_url"):
					var http_request: HTTPRequest = HTTPRequest.new()
					add_child(http_request)
					http_request.connect("request_completed", self, "_on_request_mascot_final", [image_type])
					request(http_request, str(json.result["o:original_url"]))
				else:
					emit_signal("request_error", "RequestCommonOmeka._on_request_mascot_step2(): property not found")
			
			_:
				push_warning("RequestCommonOmeka._on_request_mascot_step2(): Unexpected results from JSON response")
		
	else:
		push_warning(str("RequestCommonOmeka._on_request_mascot_step2(): response code return error: ", response_code))


func _on_request_mascot_final(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, image_type: String) -> void:
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
			emit_signal("request_error", "RequestCommonOmeka._on_request_mascot_final()): image format is not supported")
		
		var image_texture: ImageTexture = ImageTexture.new()
		image_texture.create_from_image(image)
		set_mascot(image_texture)
		emit_signal("request_mascot_completed")
		
	else:
		push_warning(str("RequestCommonOmeka._on_request_mascot_final()): response code return error: ", response_code))


func _on_request_pet_step1(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))
		
		match(typeof(json.result)):
			TYPE_DICTIONARY:
					
				if json.result.has("foaf:img"):
					if json.result["foaf:img"][0].has("@id"):
						var http_request: HTTPRequest = HTTPRequest.new()
						add_child(http_request)
						http_request.connect("request_completed", self, "_on_request_pet_step2")
						request(http_request, str(json.result["foaf:img"][0]["@id"]))
					
					else:
						emit_signal("request_error", "RequestCommonOmeka._on_request_pet_step1(): property not found")
				else:
					emit_signal("request_error", "RequestCommonOmeka._on_request_pet_step1(): property not found")
			
			_:
				push_warning("RequestCommonOmeka._on_request_pet_step1(): Unexpected results from JSON response")
		
	else:
		push_warning(str("RequestCommonOmeka._on_request_pet_step1(): response code return error: ", response_code))


func _on_request_pet_step2(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))
		
		match(typeof(json.result)):
			TYPE_DICTIONARY:
				
				var image_type: String = String()
				if json.result.has("o:media_type"): # EX. "image/png"
					image_type = str(json.result["o:media_type"]).split("/")[1]
				else:
					emit_signal("request_error", "RequestCommonOmeka._on_request_pet_step2(): image format not found")
					
				if json.result.has("o:original_url"):
					var http_request: HTTPRequest = HTTPRequest.new()
					add_child(http_request)
					http_request.connect("request_completed", self, "_on_request_pet_final", [image_type])
					request(http_request, str(json.result["o:original_url"]))
				else:
					emit_signal("request_error", "RequestCommonOmeka._on_request_pet_step2(): property not found")
			
			_:
				push_warning("RequestCommonOmeka._on_request_pet_step2(): Unexpected results from JSON response")
		
	else:
		push_warning(str("RequestCommonOmeka._on_request_pet_step2(): response code return error: ", response_code))


func _on_request_pet_final(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, image_type: String) -> void:
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
			emit_signal("request_error", "RequestCommonOmeka._on_request_pet_final()): image format is not supported")
		
		var image_texture: ImageTexture = ImageTexture.new()
		image_texture.create_from_image(image)
		set_pet(image_texture)
		emit_signal("request_pet_completed")
		
	else:
		push_warning(str("RequestCommonOmeka._on_request_pet_final()): response code return error: ", response_code))

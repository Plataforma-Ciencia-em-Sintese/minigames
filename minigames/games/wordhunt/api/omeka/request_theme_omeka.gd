#tool
class_name RequestThemeOmeka #, res://class_name_icon.svg
extends RequestTheme


#  [DOCSTRING]


#  [SIGNALS]
signal request_main_completed
signal request_colors_completed
signal request_background_texture_completed


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
	print("RequestThemeOmeka call _ready()")
	_request_main()
	_request_colors()
	_request_background_texture()
	
	yield(self, "request_background_texture_completed")
	# called upon completion of all requests
	emit_signal("all_request_theme_completed")

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
		emit_signal("request_error", "RequestThemeOmeka._request_main(): property not found")
 

func _request_colors() -> void:
	yield(self, "request_main_completed")

	if get_resources().has("game:belongsTo"):
		var http_request: HTTPRequest = HTTPRequest.new()
		add_child(http_request)
		http_request.connect("request_completed", self, "_on_request_colors")
		request(http_request, str(get_resources()["game:belongsTo"][0]["@id"]))
			
	else:
		emit_signal("request_error", "RequestThemeOmeka._request_colors(): property not found")


func _request_background_texture() -> void:
	yield(self, "request_colors_completed")

	if get_resources().has("game:belongsTo"):
		var http_request: HTTPRequest = HTTPRequest.new()
		add_child(http_request)
		http_request.connect("request_completed", self, "_on_request_background_texture_step1")
		request(http_request, str(get_resources()["game:belongsTo"][0]["@id"]))
			
	else:
		emit_signal("request_error", "RequestThemeOmeka._request_background_texture(): property not found")


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
						emit_signal("request_error", "RequestThemeOmeka._on_request_main(): The resource model ID is valid but does not match as expected")
				else:
					emit_signal("request_error", "RequestThemeOmeka._on_request_main(): property not found")
				
			_:
				emit_signal("request_error", "RequestThemeOmeka._on_request_main(): Unexpected results from JSON response")
		
	else:
		emit_signal("request_error", str("RequestThemeOmeka._on_request_main(): response code return error: ", response_code))


func _on_request_colors(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))
		
		match(typeof(json.result)):
			TYPE_DICTIONARY:
				
				if json.result.has("bibframe:colorContent"):
					set_primary_color(str(json.result["bibframe:colorContent"][0]["@value"]))
					set_secondary_color(str(json.result["bibframe:colorContent"][1]["@value"]))
					emit_signal("request_colors_completed")
				else:
					emit_signal("request_error", "RequestThemeOmeka._on_request_colors(): property not found")
					
			_:
				emit_signal("request_error", "RequestThemeOmeka._on_request_colors(): Unexpected results from JSON response")
		
	else:
		emit_signal("request_error", str("RequestThemeOmeka._on_request_colors(): response code return error: ", response_code))


func _on_request_background_texture_step1(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))
		
		match(typeof(json.result)):
			TYPE_DICTIONARY:
				
				if json.result.has("foaf:img"):
					var http_request: HTTPRequest = HTTPRequest.new()
					add_child(http_request)
					http_request.connect("request_completed", self, "_on_request_background_texture_step2")
					request(http_request, str(json.result["foaf:img"][0]["@id"]))
				else:
					emit_signal("request_error", "RequestThemeOmeka._on_request_background_texture_step1(): property not found")
					
			_:
				emit_signal("request_error", "RequestThemeOmeka._on_request_background_texture_step1(): Unexpected results from JSON response")
		
	else:
		emit_signal("request_error", str("RequestThemeOmeka._on_request_background_texture_step1(): response code return error: ", response_code))


func _on_request_background_texture_step2(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		var json := JSON.parse(body.get_string_from_utf8())
		#print(str(JSON.print(json.result, "\t")))
		
		match(typeof(json.result)):
			TYPE_DICTIONARY:
				
				var image_type: String = String()
				if json.result.has("o:media_type"): # EX. "image/png"
					image_type = str(json.result["o:media_type"]).split("/")[1]
				else:
					emit_signal("request_error", "RequestThemeOmeka._on_request_background_texture_step2(): image format not found")
				
				# get image-url
				if json.result.has("o:original_url"):
					var http_request: HTTPRequest = HTTPRequest.new()
					add_child(http_request)
					http_request.connect("request_completed", self, "_on_request_background_texture_final", [image_type], 1)
					request(http_request, str(json.result["o:original_url"]))
				else:
					emit_signal("request_error", "RequestThemeOmeka._on_request_background_texture_step2(): image-url, property not found")
					
			_:
				emit_signal("request_error", "RequestThemeOmeka._on_request_background_texture_step2(): Unexpected results from JSON response")
		
	else:
		emit_signal("request_error", str("RequestThemeOmeka._on_request_background_texture_step2(): response code return error: ", response_code))


func _on_request_background_texture_final(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray, image_type: String) -> void:
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
			emit_signal("request_error", "RequestThemeOmeka._on_request_background_texture_final(): image format is not supported")
		
		var image_texture: ImageTexture = ImageTexture.new()
		image_texture.create_from_image(image)
		
		set_background_texture(image_texture)
		emit_signal("request_background_texture_completed")
		
	else:
		emit_signal("request_error", str("RequestThemeOmeka._on_request_background_texture_final(): response code return error: ", response_code))

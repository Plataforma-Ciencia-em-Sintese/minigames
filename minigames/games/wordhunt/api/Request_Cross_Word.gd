extends HTTPRequest


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]
#enum GameMode {EASY, MEDIUM, HARD}


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]
var dicio = {}
var semaforo = Semaphore.new()
var test_input = "http://localhost:8000/jsons/23686.json"
#var test_input = "https://repositorio.canalciencia.ibict.br/api/items/23686"
var loaded = false
const BASE_URL: String = "https://repositorio.canalciencia.ibict.br/api/items/"


#  [PRIVATE_VARIABLES]
#var request_mode: int = GameMode.EASY
var _game_id := 25308

#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VIRTUAL_METHOD]

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("api ready")
#	print("javascript: ", OS.has_feature("HTML5"))
#	print("android: ", OS.has_feature("Android"))
#	var link = test_input
#	var link = OS.get_cmdline_args()[-1]
#	self._requisitar_json(link)
#	connect("read_url_parameters_completed", self, "_on_Api_read_url_parameters_completed")
	print("isso não deveria ser executado")
	_read_url_parameters()
	
#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]


#  [PUBLIC_METHODS]
func set_game_id(id: int) ->void:
	_game_id = id

func set_skip_article(skip: bool) -> void:
	pass

#  [PRIVATE_METHODS]

func _requisitar_json(link: String):
#	print("vish")
#	print(link)
	var result = -1
	var requi
	var retorno
	var saida
	while result != 0:
#		requi = self.request(link)
		requi = self.request(link, PoolStringArray( ), false) # isso precisa ser reparado
		retorno = yield(self, "request_completed")
		var saida3 = retorno[3].get_string_from_utf8()
#		print(saida3)
		saida = JSON.parse(saida3).result
		result = retorno[0]
#		print(result)
	dicio = saida
	self.loaded = true
#	ProcessData.start_process()
#	self.semaforo.post()
	
#	self.semaforo.post()
#	return saida

func _read_url_parameters() -> void:
	# Get URL parameters
	var raw_string: String = ""
	if str(OS.get_name()) == "HTML5":
		# The Javascript Class only works for HTML5.
		raw_string = str(JavaScript.eval("location.search.split('?')[1];"))
	else:
		# For testing in environments other than HTML5.
		var fake_url_parameters: String = "id=25308&trash=000&skip=1"
		raw_string = fake_url_parameters

	var strings: PoolStringArray = raw_string.split("&")

	var parameters: Dictionary = {}
	for item in strings:
		parameters[item.split("=")[0]] = item.split("=")[1]

	# Set ID
	if parameters.has("id"):
		set_game_id(int(parameters["id"]))

	# Set Skip Article
	if parameters.has("skip"):
		match(int(parameters["skip"])):
			0:
				set_skip_article(false)
			1:
				set_skip_article(true)
			_:
				set_skip_article(false)
	
	_on_Api_read_url_parameters_completed()
#	emit_signal("read_url_parameters_completed")

#  [SIGNAL_METHODS]

func _on_Api_read_url_parameters_completed() -> void:
	var link = BASE_URL + str(_game_id) #+ "/"
	_requisitar_json(link)

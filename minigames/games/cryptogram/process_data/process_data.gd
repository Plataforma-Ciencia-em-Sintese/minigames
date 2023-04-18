#class_name ProcessData#, res://class_name_icon.svg
extends Node
#extends Request
class_name ProcessData#, res://class_name_icon.svg



#  [DOCSTRING]


#  [SIGNALS]
signal game_data_processed
signal game_data_loaded
signal generated_cross_word

#  [ENUMS]


#  [CONSTANTS]
const V_SCORE = 1.0
const H_SCORE = 0.8
const LOAD_TIME = 1000 # tempo em milisegundos
const SPECIAL_CHAR_DICIO = {'Á': 'A', 'À': 'A', 'Ã': 'A', 'Â': 'A', 'É': 'E', 'È': 'E', 'Ẽ': 'E', 'Ê': 'E', 'Í': 'I', 'Ì': 'I', 'Ĩ': 'I', 'Î': 'I', 'Ó': 'O', 'Ò': 'O', 'Õ': 'O', 'Ô': 'O', 'Ú': 'U', 'Ù': 'U', 'Ũ': 'U', 'Û': 'U', 'Ç': 'C', 'Ñ': 'N', '': ' ', ' ': ' '}

#const GLOSSARY_PATH = "res://process_data/glossario_acentuacao.json"

#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]
var _words: Dictionary = Dictionary() \
		setget set_words, get_words

var _game_data = {}
var _special_char = {}

var _game_contains = []
var _keyset = []
var _everything_okay: bool


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VIRTUAL_METHOD]
func _ready() -> void:
	_everything_okay = false
	seed(OS.get_unix_time())
	_gen_cross_word()
	_gen_keyset(16)
	_global_keyset()
#	print("vish")
#	Api.connect("request_completed", self, "_start_process")
	

#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func reset() -> void:
	_gen_cross_word()
	_gen_keyset(16)
	_global_keyset()

func start_process() -> void:
#	seed(OS.get_unix_time())
##	print(Api.dicio)
##	_gen_special_char_dicio()
##	_parse_game_data(Api.dicio["game:contains"])
#	_parse_game_data(_game_contains)
##	for i in _words:
##		print(i)
#	_gen_cross_word(_words)
#	_gen_keyset(16)
#	_global_keyset()
	print("isso não deve ser executado")
#	print(get_game())

func get_keyset() -> Array:
	return _keyset

func get_game() -> Dictionary:
#	var output := {}
#	return output
	return _game_data

func set_game_contains(contains:Array) -> void:
	_game_contains = contains
	
func get_words() -> Dictionary:
	return _words

func set_words(words: Dictionary) ->void:
#	_words = words
	for i in words:
		_words[i.to_upper()] = {"key": i.to_upper(),
								"value": words[i]["clue"]}
	emit_signal("game_data_loaded")

#  [PRIVATE_METHODS]
#func _gen_special_char_dicio() -> void:
#	var glossary = File.new()
#	glossary.open(GLOSSARY_PATH, File.READ)
#	var output = JSON.parse(glossary.get_as_text()).result
#	for i in output:
#		for j in output[i]:
#			_special_char[j] = i

func _parse_game_data(raw_data:Array) -> void:
	for i in raw_data:
		var entry = i["@value"] as String
		var key_value
		if "|" in entry:
			key_value = entry.split("|")
		if ":" in entry:
			key_value = entry.split(":")
		_words[key_value[0].to_upper()] = {"key": key_value[0].to_upper(),
								"value": key_value[1]}

func _gen_complete_graph(input: Dictionary) -> Dictionary:
	var output := {}
	for i in input:
#		print(input[i]["value"])
		output[i] = {"possible": [],
					"neighbors": [],
					"acess": false,
					"clue": input[i]["value"]}
	
	for i in output:
		for k in i:
			output[i]["neighbors"].append(k)
		for j in output:
			for k in i:
				if (i != j and k in j and not j in output[i]["possible"]):
					output[i]["possible"].append(j)
	
	return output

func _gen_entry(graph: Dictionary) -> Dictionary:
	var neighborhood = []
	var output = {}
	var keys = graph.keys()
	var orientation = randi()
	keys.shuffle()
	while len(keys) > 0:
		var actual = keys.pop_front()
		if output.size() == 0:
			output[actual] = graph[actual]
			output[actual]["horizontal"] = (orientation%2 == 1)
			neighborhood.append_array(graph[actual]["possible"])
		elif actual in neighborhood:
			var actual_keys = output.keys()
			var neighbor = actual_keys[randi()%len(actual_keys)]
			output[actual] = graph[actual]
			
			var vertex_actual = randi()%len(actual)
			var vertex_neighbor = randi()%len(neighbor)
			
			while actual[vertex_actual] != output[neighbor]["neighbors"][vertex_neighbor]:
				vertex_actual = randi()%len(actual)
				neighbor = actual_keys[randi()%len(actual_keys)]
				vertex_neighbor = randi()%len(neighbor)
			
			output[actual]["neighbors"][vertex_actual] = neighbor
			output[neighbor]["neighbors"][vertex_neighbor] = actual
			output[actual]["horizontal"] = not output[neighbor]["horizontal"]
			neighborhood.append_array(graph[actual]["possible"])
			
			# Atualiza a vizinhanca
			neighborhood = []
			for i in output.keys():
				for j in output[i]["possible"]:
					if j in output.keys():
						continue
					else:
						for k in output[i]["neighbors"]:
							if (len(k) == 1 and k in j):
								neighborhood.append(j)
		
		elif keys.empty():
			# TODO
			# reinicia o processo
			pass
		else:
			# TODO
			# Verifica se ha solucao
			keys.push_back(actual)
	return output

func _deep_search(graph: Dictionary, item: String) -> void:
	for i in range(len(graph[item]["neighbors"])):
		var item_i = graph[item]["neighbors"][i]
		if item_i in graph:
			if not "position" in graph[item_i].keys():
				if graph[item_i]["horizontal"]:
					graph[item_i]["direction"] = Vector2.RIGHT
				else:
					graph[item_i]["direction"] = Vector2.DOWN
				var pos_j = graph[item_i]["neighbors"].find(item)
				graph[item_i]["position"] = graph[item]["position"] + graph[item]["direction"]*i - graph[item_i]["direction"]*pos_j
				_deep_search(graph, item_i)

func _validate_graph(graph: Dictionary) -> bool:
	# Primeiro se valida se todas as arestas existem
	for i in graph.keys():
		var graph_is_connected = false
		for j in graph[i]["neighbors"]:
			if (j in graph.keys()):
				graph_is_connected = true
		if not graph_is_connected:
			return false
	
	# Calcula a posicao de inicio de cada palavra
	var start = graph.keys()[randi()%len(graph.keys())]
	graph[start]["position"] = Vector2.ZERO
	if graph[start]["horizontal"]:
		graph[start]["direction"] = Vector2.RIGHT
	else:
		graph[start]["direction"] = Vector2.DOWN
	
	_deep_search(graph, start)
	var offset = Vector2.ZERO
	for i in graph:
		if graph[i]["position"].x < offset.x:
			offset.x = graph[i]["position"].x
		if graph[i]["position"].y < offset.y:
			offset.y = graph[i]["position"].y
	
	offset -= Vector2.ONE
	
	var map = {}
	for i in graph.keys():
		graph[i]["position"] -= offset
#		graph[i]["solved"] = false
		for j in range(len(i)):
			var str_position = String(graph[i]["position"] + graph[i]["direction"]*j)
			if not str_position in map:
				map[str_position] = i[j] #letra da palavra
			elif map[str_position] != i[j]:
				return false
	
	## Verifica se ha alguma letra antes ou depois da palavra
	for i in graph.keys():
		
		# Pega a posicao anterior a primeira
		var pre_first = graph[i]["position"] - graph[i]["direction"]
		# pega a posicao apos a final
		var pos_final = graph[i]["position"] + graph[i]["direction"]*(len(i))
		
		# Verificam se estao livres
		if (str(pre_first) in map or str(pos_final) in map):
#			print("vish")
			return false
	
#	print(map)
	
	return true

func _graph_score(graph: Dictionary) -> float:
	var start_point = Vector2.ZERO
	var end_point = Vector2.ZERO
	
	for i in graph:
		var first_letter = graph[i]["position"]
		var last_letter = graph[i]["position"] + graph[i]["direction"] * (len(i)-1)
		if (first_letter.x < start_point.x):
			start_point.x = first_letter.x
		if (first_letter.y < start_point.y):
			start_point.y = first_letter.y
		if (last_letter.x > end_point.x):
			end_point.x = last_letter.x
		if (last_letter.y > end_point.y):
			end_point.y = last_letter.y
	
	var size = end_point - start_point
	
	return size.x * size.x * size.x *H_SCORE + size.y * size.y * size.y * V_SCORE

func _gen_game_table(complete_graph: Dictionary) -> Dictionary:
	
	var actual_time = OS.get_ticks_msec()
	var best_graph = _gen_entry(complete_graph.duplicate(true))
	var best_validate = _validate_graph(best_graph)
	var best_score = _graph_score(best_graph)
	var start_time = OS.get_ticks_msec()
	while not (actual_time > start_time + LOAD_TIME):
#	while not (actual_time > start_time + LOAD_TIME and best_validate):
		actual_time = OS.get_ticks_msec()
		var new_entry = _gen_entry(complete_graph.duplicate(true))
		var new_validate = _validate_graph(new_entry)
		var new_score = _graph_score(new_entry)
		
		if (new_validate):
			if not best_validate:
				best_graph = new_entry
				best_score = new_score
				best_validate = true
			elif (best_score > new_score):
				best_graph = new_entry
				best_score = new_score
#	print(best_graph)
	return best_graph


func _gen_cross_word() -> void:
	yield(self, "game_data_loaded")
	var adj = _gen_complete_graph(_words)
#	var puzzle = _gen_game_table(adj)
	_game_data = _gen_game_table(adj)
	emit_signal("generated_cross_word")
#	print(puzzle)

func _global_keyset() -> void:
	yield(self, "generated_cross_word")
	var letters = _all_keys()
	
	var lines = ceil(len(_all_keys())/4.0)
	
	for i in range(int(lines*4)-len(letters)):
		letters.append("")
	_keyset = letters
	_keyset.shuffle()
#	print(letters)
#	print("tudo, tudo, tudo vai dar certo")
	_everything_okay = true

func _gen_keyset(size: int) -> void:
	yield(self, "generated_cross_word")
	var letters = _all_keys()
#	print(letters)
#	print(len(letters))
	
	for i in _game_data:
		_game_data[i]["keyboard"] = []
		for j in i:
			var subset = []
			if j != " ":
				if not j in letters:
					subset.append(SPECIAL_CHAR_DICIO[j])
				else:
					subset.append(j)
			else:
				subset.append(letters[0])
			for k in range(size-1):
				letters.shuffle()
				subset.append(letters[0])
			subset.shuffle()
			_game_data[i]["keyboard"].append(subset)
			

func _all_keys() -> Array:
	var output = []
	output.append(" ")
	for i in _game_data:
		for j in i:
			var jk = j
			if SPECIAL_CHAR_DICIO.has(jk):
				jk = SPECIAL_CHAR_DICIO[jk]
			if not (jk in output):
				output.append(jk)
	output.pop_front()
	return output

#  [SIGNAL_METHODS]
#func _start_process() -> void:
#	print("vish")

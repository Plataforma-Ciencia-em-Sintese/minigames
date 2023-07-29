class_name StringHandler
extends Resource


static func random_letter(uppercase: bool ) -> String:
	randomize()

	if uppercase:
		# "A" for uppercase ascii_code letters
		return char(ord("A") + randi() % 26)
	else:
		# "a" for lowercase ascii_code letters
		return char(ord("a") + randi() % 26)


static func remove_accent(word: String) -> String:
	var accent_map: Dictionary = {
		"á": "a", "à": "a", "ã": "a", "â": "a", "ä": "a",
		"é": "e", "è": "e", "ê": "e", "ë": "e",
		"í": "i", "ì": "i", "î": "i", "ï": "i",
		"ó": "o", "ò": "o", "õ": "o", "ô": "o", "ö": "o",
		"ú": "u", "ù": "u", "û": "u", "ü": "u",
		"ç": "c",
		"Á": "A", "À": "A", "Ã": "A", "Â": "A", "Ä": "A",
		"É": "E", "È": "E", "Ê": "E", "Ë": "E",
		"Í": "I", "Ì": "I", "Î": "I", "Ï": "I",
		"Ó": "O", "Ò": "O", "Õ": "O", "Ô": "O", "Ö": "O",
		"Ú": "U", "Ù": "U", "Û": "U", "Ü": "U",
		"Ç": "C"
	}

	var word_without_accent: String = ""
	for letter in word:
		if accent_map.has(letter):
			word_without_accent += accent_map[letter]
		else:
			word_without_accent += letter

	return word_without_accent


static func removes_special_characters(word: String) -> String:
	var special_characters: Array = [
	  " ", "!", "@", "#", "$",
	  "%", "^", "&", "*", "(",
	  ")", "-", "_", "=", "+",
	  "[", "]", "{", "}", "|",
	  ";", ":", "'", "\"", "<",
	  ">", ",", ".", "?", "/",
	  "\\"
	]

	var string_without_special_characters: String = ""
	for letter in word:
		if not letter in special_characters:
			string_without_special_characters += letter

	return string_without_special_characters






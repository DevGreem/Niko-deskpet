extends Resource

class_name AIMessageContent

enum Type {
	INPUT_TEXT,
	OUTPUT_TEXT
}

var type: Type
var text: String

static func create(_type: Type, _text: String) -> AIMessageContent:
	var content := AIMessageContent.new()
	content.type = _type
	content.text = _text
	
	return content

func to_dict() -> Dictionary[String, String]:
	return {
		"type": (Type.find_key(type) as String).to_lower(),
		"text": text
	}

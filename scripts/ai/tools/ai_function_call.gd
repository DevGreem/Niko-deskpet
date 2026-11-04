extends JsonObject

class_name AIFunctionCall

@export var name: String
@export var arguments: Dictionary[String, Variant] = {}

func to_dict() -> Dictionary[String, Variant]:
	return {
		"name": name,
		"arguments": arguments
	}

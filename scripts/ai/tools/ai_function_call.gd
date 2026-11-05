extends JsonObject

class_name AIFunctionCall

@export var name: String
@export var arguments: Dictionary[String, Variant] = {}

func to_dict() -> Dictionary[String, Variant]:
	return {
		"name": name,
		"arguments": arguments
	}

func from_dict(dict: Dictionary, _set_objects := false) -> void:
	name = dict.get("name", "")
	arguments.assign(
		JSON.parse_string(dict["arguments"])
	)

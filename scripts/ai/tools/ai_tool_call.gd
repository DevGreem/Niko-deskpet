extends JsonObject

class_name AIToolCall

var id: String
@export var type: AIToolTypes.Types
@export var function: AIFunctionCall

func to_dict() -> Dictionary[String, Variant]:
	return {
		"id": id,
		"type": AIToolTypes.to_lower(type),
		"function": function.to_dict()
	}

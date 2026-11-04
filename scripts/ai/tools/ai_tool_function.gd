extends JsonObject

class_name AIToolFunction

@export var name: String
@export_multiline() var description: String
@export var parameters: AIToolFunctionParameters = null
@export var strict := false

func to_dict() -> Dictionary[String, Variant]:
	return {
		"name": name,
		"description": description,
		"parameters": parameters.to_dict(),
		"strict": strict
	}

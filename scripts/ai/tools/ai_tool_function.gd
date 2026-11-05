extends JsonObject

class_name AIToolFunction

@export var name: String
@export_multiline() var description: String
@export var parameters: AIToolFunctionParameters = null
@export var strict := false

func to_dict() -> Dictionary[String, Variant]:
	var dict: Dictionary[String, Variant] = {
		"name": name,
		"description": description,
		"strict": strict
	}
	
	if parameters or strict:
		dict["parameters"] = parameters.to_dict()
	
	return dict

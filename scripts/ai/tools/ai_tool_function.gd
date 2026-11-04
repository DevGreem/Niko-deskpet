extends Resource

class_name AIToolFunction

@export var name: String
@export var description: String
@export var parameters: AIToolFunctionParameters
@export var strict := false

func to_dict() -> Dictionary[String, Variant]:
	return {
		"name": name,
		"description": description,
		"parameters": parameters.to_dict(),
		"strict": strict
	}

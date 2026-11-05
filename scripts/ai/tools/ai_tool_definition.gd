extends JsonObject

class_name AIToolDefinition

@export var type: AIToolTypes.Types

@export var function: AIToolFunction

func to_dict() -> Dictionary[String, Variant]:
	
	var general: Dictionary[String, Variant] = {
		"type": AIToolTypes.to_lower(type)
	}
	
	if type == AIToolTypes.Types.FUNCTION:
		_function_dict(general)
	
	return general

func _function_dict(dict: Dictionary[String, Variant]) -> void:
	dict["function"] = function.to_dict()

func _validate_property(property: Dictionary) -> void:
	
	if property.name == "function" and type != AIToolTypes.Types.FUNCTION:
		property.usage = PROPERTY_USAGE_NONE

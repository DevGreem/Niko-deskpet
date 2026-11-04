extends Resource

class_name AIToolDefinition

enum Types {
	FUNCTION,
	CODE_INTERPRETER,
	FILE_SEARCH,
	MCP
}

@export var type: Types

@export var function: AIToolFunction

func to_dict() -> Dictionary[String, Variant]:
	
	var general: Dictionary[String, Variant] = {
		"type": str(Types.find_key(type)).to_lower()
	}
	
	if type == Types.FUNCTION:
		_function_dict(general)
	
	return general

func _function_dict(dict: Dictionary[String, Variant]) -> void:
	dict["function"] = function.to_dict()

func _validate_property(property: Dictionary) -> void:
	
	if property.type == Types.FUNCTION:
		pass
	else:
		property.usage = PROPERTY_USAGE_NONE

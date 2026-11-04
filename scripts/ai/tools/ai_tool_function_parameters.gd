extends Resource

class_name AIToolFunctionParameters

enum Types {
	OBJECT
}

@export var type: Types
@export var properties: Dictionary[String, AIToolFunctionParameterProperty] = {}
@export var required: Array[String] = []
@export var additional_properties := false

func to_dict() -> Dictionary[String, Variant]:
	
	var props: Dictionary[String, Dictionary] = {}
	
	for key: String in properties.keys():
		props[key] = properties[key].to_dict()
	
	return {
		"type": str(Types.find_key(type)).to_lower(),
		"properties": props,
		"required": required,
		"additionalProperties": additional_properties
	}

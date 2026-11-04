@tool
extends JsonObject

class_name AIToolFunctionParameters

enum Types {
	OBJECT
}

@export var type: Types

@export var _properties_inspector: Array[AIToolFunctionParameterProperty] = []:
	set(value):
		
		_properties_inspector = value
		
		properties.clear()
		for prop: AIToolFunctionParameterProperty in _properties_inspector:
			properties[prop.name] = prop

@export_storage var properties: Dictionary[String, AIToolFunctionParameterProperty] = {}
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

func _validate_property(property: Dictionary) -> void:
	
	if property.name == "required":
		property.hint_string = "%d/%d:%s" % [
			TYPE_STRING,
			PROPERTY_HINT_ENUM_SUGGESTION,
			",".join(properties.keys())
		]

@tool
extends JsonObject

class_name AIToolFunctionParameterProperty

enum Types {
	OBJECT,
	STRING,
	NUMBER,
	INTEGER,
	BOOLEAN,
	ARRAY,
	ENUM,
	ANY_OF
}

@export var name: String
@export var type: String:
	set(value):
		type = value
		notify_property_list_changed()

@export_multiline() var description: String
@export var enum_val: Array[String] = []

static func get_camel_type(_type: Types) -> String:
	return str(Types.find_key(_type)).to_camel_case()

func to_dict() -> Dictionary[String, Variant]:
	
	var dict: Dictionary[String, Variant] = {
		"type": type.to_camel_case(),
		"description": description
	}
	
	if not enum_val.is_empty():
		dict["enum"] = enum_val
	
	return dict

func _validate_property(property: Dictionary) -> void:
	
	if property.name == "type":
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = ",".join(Types.keys().map(
			func(val: String) -> String:
				return val.to_camel_case()
		))
	
	if property.name == "enum_val":
		if not type == AIToolFunctionParameterProperty.get_camel_type(Types.STRING):
			property.usage = PROPERTY_USAGE_NONE
	

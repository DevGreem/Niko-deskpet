extends Resource

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
@export var type: String
@export var description: String
@export var enum_val: Array[String] = []

func to_dict() -> Dictionary[String, Variant]:
	
	var dict: Dictionary[String, Variant] = {
		"type": type.to_camel_case(),
		"description": description
	}
	
	if not enum_val.is_empty():
		dict["enum"] = enum_val
	
	return dict

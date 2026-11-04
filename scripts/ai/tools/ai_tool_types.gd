extends Resource

class_name AIToolTypes

enum Types {
	FUNCTION,
	CODE_INTERPRETER,
	FILE_SEARCH,
	MCP
}

static func to_lower(type: Types) -> String:
	return str(Types.find_key(type)).to_lower()

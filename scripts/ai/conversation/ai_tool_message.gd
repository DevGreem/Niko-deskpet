extends AIMessage

class_name AIToolMessage

@export var tool_call_id: String

static func create(_role: Role, _content: String, id: String = "") -> AIToolMessage:
	var instance := AIToolMessage.new()
	instance.role = _role
	instance.content = _content
	instance.tool_call_id = id
	
	return instance

func to_dict() -> Dictionary[String, Variant]:
	
	var ans := super.to_dict()
	ans["role"] = "tool"
	ans["tool_call_id"] = tool_call_id
	
	return ans

extends AIMessage

class_name AIToolMessage

@export var tool_call_id: String

func to_dict() -> Dictionary[String, Variant]:
	
	var ans := super.to_dict()
	ans["role"] = "tool"
	ans["tool_call_id"] = tool_call_id
	
	return ans

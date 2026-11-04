extends Resource

class_name AIMessage

enum Role {
	SYSTEM,
	USER,
	ASSISTANT,
	TOOL
}

@export var role: Role
@export_multiline() var content: String

static func create(_role: Role, _content: String) -> AIMessage:
	var message := AIMessage.new()
	message.role = _role
	message.content = _content
	
	return message

func to_dict() -> Dictionary[String, Variant]:
	
	return {
		"role": str(Role.find_key(role)).to_lower(),
		"content": content
	}

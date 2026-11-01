extends Resource

class_name AIConversation

const PATH := "user://conversation.tres"

@export_storage var conversation_id: int = ResourceUID.create_id()
@export var model: String = ""
@export var variant: String = ""

@export_storage var _memory: Array[AIMessage] = []

static func load_conversation(path := PATH) -> AIConversation:
	
	if not ResourceLoader.exists(path):
		var conversation := AIConversation.new()
		conversation.save(path)
		return conversation
	
	return ResourceLoader.load(path)

func save(path := PATH) -> void:
	ResourceSaver.save(self, path)

func clear_memory() -> void:
	_memory.clear()

func add_memory(message: AIMessage) -> void:
	_memory.append(message)

func add_memories(memories: Array[AIMessage]) -> void:
	_memory.append_array(memories)

func get_memory_size() -> int:
	return _memory.size()

func is_memory_empty() -> bool:
	return _memory.is_empty()

func to_dict() -> Array[Dictionary]:
	
	var messages: Array[Dictionary] = []
	
	for message: AIMessage in _memory:
		messages.append(message.to_dict())
	
	return messages

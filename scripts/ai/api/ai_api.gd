extends Resource

class_name AIApi

@export var conversation := AIConversation.new()

var _http_request: HTTPRequest
var url: String
var _api_key: String
var is_api_connected := false

func connect_api(requester: HTTPRequest, _url: String, api_key: String) -> bool:
	
	if is_api_connected:
		return false
	
	_http_request = requester
	_http_request.request_completed.connect(_on_request_completed)
	url = _url
	_api_key = api_key
	is_api_connected = true
	conversation = AIConversation.load_conversation()
	
	return true

func add_message(message: AIMessage) -> void:
	conversation.add_memory(message)

func add_messages(message: Array[AIMessage]) -> void:
	conversation.add_memories(message)

func prompt() -> void:
	_http_request.request(
		url,
		_get_headers(),
		HTTPClient.METHOD_POST,
		JSON.stringify(_get_body())
	)

func _on_request_completed(...params: Array) -> void:
	conversation.save()

func _get_headers() -> Array[String]:
	return [
		"Content-Type: application/json",
		"Authorization: Bearer %s" % [_api_key]
	]

func _get_body() -> Dictionary[String, Variant]:
	
	var final_model := conversation.model
	
	if not conversation.variant.is_empty():
		final_model += "#" + conversation.variant
	
	return {
		"model": final_model,
		"messages": conversation.to_dict()
	}

func _get_choice(output: Dictionary, idx: int) -> Dictionary:
	return output["choices"][idx]

func _get_choices(output: Dictionary) -> Array[Dictionary]:
	return output["choices"]

## Deepsek api by default XD
func get_output(output: Dictionary) -> String:
	
	if not output.has("choices"):
		return ""
	
	return _get_choice(output, 0)["message"]["content"]

## Deepseek api by default (same as up)
func get_outputs(output: Dictionary) -> Array[String]:
	
	if not output.has("choices"):
		return []
	
	var arr: Array[String] = []
	
	var choices: Array = output["choices"]
	
	for i: int in range(choices.size()):
		arr.append(
			str(_get_choice(output, i)["message"]["content"])
		)
	
	return arr

func get_tools_called(dict: Dictionary) -> Array[Dictionary]:
	
	var choices := _get_choices(dict)
	
	for choice: Dictionary in choices:
		pass
	
	return []

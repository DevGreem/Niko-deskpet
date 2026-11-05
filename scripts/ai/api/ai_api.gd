extends Resource

class_name AIApi

@export var conversation := AIConversation.new()

var _http_request: HTTPRequest
var url: String
var _tools: Dictionary[String, AIToolDefinition] = {}
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

func add_tool(tool: AIToolDefinition) -> void:
	
	if tool.type == AIToolTypes.Types.FUNCTION:
		_tools[tool.function.name] = tool

func remove_tool(tool_name: String) -> bool:
	return _tools.erase(tool_name)

func add_tools(tools: Array[AIToolDefinition]) -> void:
	
	for tool: AIToolDefinition in tools:
		add_tool(tool)

func prompt() -> void:
	
	var body := _get_body()
	
	print("Prompting message with body: ", JSON.stringify(body, "\t"))
	
	_http_request.request(
		url,
		_get_headers(),
		HTTPClient.METHOD_POST,
		JSON.stringify(body)
	)

func _on_request_completed(..._params: Array) -> void:
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
		"messages": conversation.to_dict(),
		"tools": _get_tools_dict(),
		"stream": false
	}

func _get_tools_dict() -> Array[Dictionary]:
	
	var arr: Array[Dictionary] = []
	
	for tool: AIToolDefinition in _tools.values():
		arr.append(tool.to_dict())
	
	return arr

func _get_choice(output: Dictionary, idx: int) -> Dictionary:
	return output["choices"][idx]

func _get_choices(output: Dictionary) -> Array[Dictionary]:
	
	var arr_dicts: Array[Dictionary] = []
	
	arr_dicts.assign(output["choices"])
	return arr_dicts

## Deepsek api by default XD
func get_output(output: Dictionary) -> String:
	
	if not output.has("choices"):
		return ""
	
	var message: Dictionary = _get_choice(output, 0).get("message", {})
	
	if message.is_empty():
		return ""
	
	var content: Variant = message.get("content")
	
	if content == null:
		return ""
	
	return content

## Deepseek api by default (same as up)
func get_outputs(output: Dictionary) -> Array[String]:
	
	if not output.has("choices"):
		return []
	
	var arr: Array[String] = []
	
	var choices: Array = output["choices"]
	
	for i: int in range(choices.size()):
		
		var message: Dictionary = _get_choice(output, 0).get("message", {})
	
		if message.is_empty():
			continue
		
		var content: String = message.get("content", "")
		
		if content.is_empty():
			continue
		
		arr.append(content)
	
	return arr

func get_tools_called(dict: Dictionary) -> Array[AIToolCall]:
	
	var tools_called: Array[AIToolCall] = []
	
	var choices := _get_choices(dict)
	
	for choice: Dictionary in choices:
		
		var message: Dictionary = choice.get("message", {})
		
		if message.is_empty():
			continue
		
		var calls: Array = message.get("tool_calls", [])
		
		if calls.is_empty():
			continue
		
		for tool_call_dict: Dictionary in calls:
			var tool_call := AIToolCall.new()
			tool_call.from_dict(tool_call_dict, true)
			
			tools_called.append(tool_call)
	
	return tools_called

func get_finish_reason_of_choice(dict: Dictionary, idx: int) -> String:
	
	var choice := _get_choice(dict, idx)
	
	var val: Variant = choice.get("finish_reason", "")
	
	if not val:
		return ""
	
	return val 

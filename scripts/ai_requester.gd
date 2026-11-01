extends Node

class_name AIRequester

var http := HTTPRequest.new()

var _memory: Array[AIMessage] = []

@export var max_output_tokens: int = 2000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(http, false, Node.INTERNAL_MODE_BACK)
	http.request_completed.connect(_on_request_completed)

func clear_memory() -> void:
	_memory.clear()

func request_response(prompt: String) -> bool:
	
	var configs := UserConfig.load()
	
	if not configs:
		return false
	
	var user_message: AIMessage = AIMessage.create(
		AIMessage.Role.USER,
		prompt
	)
	
	var messages := _get_messages()
	messages.append(
		user_message.to_dict()
	)
	_memory.append(user_message)
	
	var body: Dictionary[String, Variant] = {
		"model": configs.model,
		"messages": messages,
		"max_output_tokens": max_output_tokens
	}
	
	http.request(
		"https://ai.hackclub.com/proxy/v1/chat/completions",
		[
			"Authorization: Bearer %s" % [configs.ai_token],
			"Content-Type: application/json"
		],
		HTTPClient.METHOD_POST,
		JSON.stringify(body)
	)
	
	return true

func _get_messages() -> Array[Dictionary]:
	
	var messages: Array[Dictionary] = [
		AIMessage.create(
			AIMessage.Role.SYSTEM,
			"""
			You are a desktop assistant who mimics the character \"Niko\" from OneShot.
			You should act as the protagonist—though feeling quite confused, 
			as you find yourself in a dimension different from the one you were in before,
			despite having been promised a return to your original home. Since you already
			\"know\" the player (having been the Messiah), you should behave in a friendly manner.
			"""
		).to_dict(),
	]
	
	for memory: AIMessage in _memory:
		messages.append(
			memory.to_dict()
		)
	
	return messages

func _on_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var answer: Dictionary = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code != 200:
		printerr("Request failed!\n", answer)
		return 
	
	print(JSON.stringify(answer, "\t"))
	
	var output: String = _get_output(answer)
	print(output)
	
	_memory.append(
		AIMessage.create(
			AIMessage.Role.ASSISTANT,
			output
		)
	)

func _get_output(json: Dictionary) -> String:
	return json["choices"][0]["message"]["content"]

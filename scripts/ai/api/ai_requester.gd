extends Node

class_name AIRequester

signal answered(answer: String)

var http := HTTPRequest.new()
@export var api: AIApi
@export var url: String

@export var start_messages: Array[AIMessage] = []
@export var max_output_tokens: int = 2000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(http, false, Node.INTERNAL_MODE_BACK)
	http.request_completed.connect(_on_request_completed)
	
	var config := UserConfig.load_res()
	
	api.connect_api(
		http,
		url,
		config.ai_token
	)
	
	if api.conversation.is_memory_empty():
		api.add_messages(start_messages)
	else:
		api.add_message(
			AIMessage.create(
				AIMessage.Role.USER,
				"""
				--- SYSTEM MESSAGE
				You have regained your sight after a period of seeing nothing but darkness,
				it’s just like when you used to lie down on the beds in the other world,
				and you are confused as to why this keeps happening to you.\
				---
				"""
			)
		)
	
	api.conversation.model = config.model

func retry_request() -> void:
	api.prompt()

func request_response(prompt: String) -> void:
	
	api.add_message(
		AIMessage.create(
			AIMessage.Role.USER,
			prompt
		)
	)
	
	retry_request()

func _on_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	
	if response_code != 200:
		printerr("Request failed for some reason!\n")
		return
	
	var answer: Dictionary = JSON.parse_string(body.get_string_from_utf8())
	
	print(JSON.stringify(answer, "\t"))
	
	var output: String = api.get_output(answer)
	print(output)
	
	api.add_message(
		AIMessage.create(
			AIMessage.Role.ASSISTANT,
			output
		)
	)
	
	answered.emit(output)

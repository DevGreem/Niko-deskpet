extends Node

class_name AIRequester

var http := HTTPRequest.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(http)

func request_response(prompt: String) -> bool:
	
	var configs := UserConfig.load()
	
	if not configs:
		return false
	
	http.request(
		"https://ai.hackclub.com/proxy/v1/chat/completions",
		[
			"Authorization: Bearer %s" % [configs.ai_token],
			"Content-Type: application/json"
		],
		HTTPClient.METHOD_POST
	)
	
	return true

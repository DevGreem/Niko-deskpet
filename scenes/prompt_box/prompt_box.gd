extends TextEdit

class_name PromptBox

signal sended

@export var manager: Node2D

@export var offset := Vector2.ZERO
@export var requester: AIRequester

func _gui_input(event: InputEvent) -> void:
	
	if not requester:
		printerr("Requested not has been added!")
		return
	
	if event.is_action_pressed("ui_text_completion_accept"):
		get_viewport().set_input_as_handled()
		send()

func _process(delta: float) -> void:
	
	if not manager:
		return
	
	global_position = manager.global_position + offset - Vector2(self.size.x/2, 0)

func send() -> void:
	requester.request_response(self.text)
	sended.emit()
	self.queue_free()

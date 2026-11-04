extends TextEdit

class_name PromptBox

signal sended

@export var pinner: Pinner
@export var requester: AIRequester

func _gui_input(event: InputEvent) -> void:
	
	if not requester:
		printerr("Requested not has been added!")
		return
	
	if event.is_action_pressed("ui_close_dialog"):
		self.queue_free()
		return
	
	if event.is_action_pressed("ui_text_completion_accept") and not Input.is_key_pressed(KEY_SHIFT):
		get_viewport().set_input_as_handled()
		send()

func send() -> void:
	requester.request_response(self.text)
	sended.emit()
	self.queue_free()

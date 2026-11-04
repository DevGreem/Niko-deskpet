@tool
extends Control

class_name OutputBox

@export var label: RichTextLabel
@export var icon: FaceTextureRect
@export var pinner: Pinner
@export var anim_player: AnimationPlayer

@export var _message_query: Array[DialogueMessage] = []
var message_query: Array[DialogueMessage]:
	get: return _message_query
	set(value): return

func _gui_input(event: InputEvent) -> void:
	
	if Engine.is_editor_hint():
		return
	
	if event.is_action_pressed("close_text"):
		if label.visible_ratio < 1.0:
			anim_player.stop()
			label.visible_ratio = 1.0
		else:
			
			if message_query.is_empty():
				queue_free()
			else:
				show_next_message()

func set_message(messages: Array[DialogueMessage]) -> void:
	_message_query = messages
	show_next_message()

func add_message(message: DialogueMessage) -> void:
	_message_query.append(message)

func show_next_message() -> bool:
	
	if _message_query.is_empty():
		return false
	
	label.visible_ratio = 0.0
	label.text = _message_query[0].message
	anim_player.play(anim_player.autoplay)
	
	icon.face = _message_query[0].icon
	
	_message_query.remove_at(0)
	return true

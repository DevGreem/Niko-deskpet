@tool
extends Control

class_name OutputBox

@export var label: RichTextLabel
@export var icon: TextureRect
@export var pinner: Pinner
@export var anim_player: AnimationPlayer

@export var _message_query: Array[DialogueMessage] = []

func _gui_input(event: InputEvent) -> void:
	
	if Engine.is_editor_hint():
		return
	
	if event.is_action_pressed("close_text"):
		if label.visible_ratio < 1.0:
			anim_player.stop()
			label.visible_ratio = 1.0
		else:
			queue_free()

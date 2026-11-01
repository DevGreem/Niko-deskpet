extends RichTextLabel

class_name OutputBox

@export var pinner: Pinner
@export var anim_player: AnimationPlayer

func _gui_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("close_text"):
		if visible_ratio < 1.0:
			anim_player.stop()
			visible_ratio = 1.0
		else:
			queue_free()

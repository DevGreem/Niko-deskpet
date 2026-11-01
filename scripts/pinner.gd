extends Node

class_name Pinner

@export var actor: CanvasItem
@export var manager: CanvasItem
@export var offset := Vector2.ZERO


func _process(delta: float) -> void:
	
	if not manager or not actor:
		return
	
	actor.global_position = manager.global_position + offset - Vector2(actor.size.x/2, 0)

extends Area2D

class_name DraggableWindow

@export var offset := Vector2i.ZERO

var _focused := false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	_focused = true

func _on_mouse_exited():
	_focused = false

func _input(event: InputEvent) -> void:
	
	if not _focused:
		return
	
	if event.is_action_pressed("drag_window", true):
		get_window().start_drag()
		print("Detected input")
	
	

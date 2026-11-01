extends Area2D

class_name DraggableWindow

@export var offset := Vector2i.ZERO

var focused := false

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	focused = true

func _on_mouse_exited() -> void:
	focused = false

func _input(event: InputEvent) -> void:
	
	if not focused:
		return
	
	if event.is_action_pressed("drag_window", true):
		get_window().start_drag()
		print("Detected input")
	

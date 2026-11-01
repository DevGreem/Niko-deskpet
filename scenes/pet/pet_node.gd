extends Node2D

class_name PetNode

@export var ai_requester: AIRequester:
	set(value):
		
		if ai_requester == value:
			return
		
		ai_requester = value
		
		if ai_requester:
			ai_requester.answered.connect(_on_answer)

@export var prompt_scene: PackedScene

@export var area: DraggableWindow

var _prompt_box: PromptBox = null

func _input(event: InputEvent) -> void:
	
	if is_instance_valid(_prompt_box) or not area.focused:
		return
	
	if event.is_action_pressed("show_actions"):
		_init_prompt_box()
		print("Detected action")

func _init_prompt_box() -> void:
	_prompt_box = prompt_scene.instantiate()
	_prompt_box.manager = self
	_prompt_box.requester = ai_requester
	
	add_child(_prompt_box)

func _on_answer(answers: Array[String]) -> void:
	pass

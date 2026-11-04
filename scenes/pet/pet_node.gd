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
@export var output_scene: PackedScene

@export var area: DraggableWindow

var _prompt_box: PromptBox = null
var _output_box: OutputBox = null

func _input(event: InputEvent) -> void:
	
	if is_instance_valid(_prompt_box) or is_instance_valid(_output_box) or not area.focused:
		return
	
	if event.is_action_pressed("show_actions"):
		_init_prompt_box()
		print("Detected action")

func _init_prompt_box() -> void:
	_prompt_box = prompt_scene.instantiate()
	_prompt_box.pinner.manager = self
	_prompt_box.requester = ai_requester
	
	add_child(_prompt_box)

func _init_output_box(output: String, icon: String) -> void:
	_output_box = output_scene.instantiate()
	_output_box.pinner.manager = self
	_output_box.label.text = output
	
	add_child(_output_box)

func _on_answer(answer: String, icon: String) -> void:
	_init_output_box(answer, icon)

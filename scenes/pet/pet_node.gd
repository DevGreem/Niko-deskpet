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

func _init_output_box(output: Array[DialogueMessage]) -> void:
	_output_box = output_scene.instantiate()
	_output_box.pinner.manager = self
	_output_box.set_message(output)
	
	add_child(_output_box)

func _on_answer(answer: String) -> void:
	
	var parsed_answer: Array = JSON.parse_string(answer)
	
	var response: Array[DialogueMessage] = []
	
	for dialogue: Dictionary in parsed_answer:
		var message := DialogueMessage.new(
			dialogue["message"],
			dialogue["icon"]
		)
		
		response.append(message)
	
	_init_output_box(response)

func move_to(x: int, y: int) -> void:
	
	var window: Window = get_window()
	
	var size := DisplayServer.window_get_size(window.get_window_id())
	
	DisplayServer.window_set_position(
		Vector2i(x+int(size.x/2.0), y+int(size.y/2.0)),
		window.get_window_id()
	)

func _on_tool_called(tool: AIToolCall) -> void:
	
	if not tool.function.name in self:
		return
		
	Callable(self, tool.function.name)
	call(tool.function.name, tool.function.arguments)

## Returns Array or Variant
func _make_args_array(method: StringName, args: Dictionary) -> Variant:
	return 

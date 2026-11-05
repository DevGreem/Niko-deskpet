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

@export var speed := Vector2.ZERO

@export var state_machine: LimboHSM	

var desktop_position: Vector2i:
	get:
		var window := get_window().get_window_id()
		var pos := DisplayServer.window_get_position(window)
		var size := DisplayServer.window_get_size(window)
		
		return Vector2i(pos.x + int(size.x/2.0), pos.y + int(size.y/2.0))


var _target_position := -Vector2i.ONE

var _prompting := false
var _prompt_box: PromptBox = null
var _output_box: OutputBox = null

func _ready() -> void:
	state_machine.initialize(self)
	state_machine.set_active(true)

func _input(event: InputEvent) -> void:
	
	if is_instance_valid(_prompt_box) or is_instance_valid(_output_box) or not area.focused or _prompting:
		return
	
	if event.is_action_pressed("show_actions"):
		_init_prompt_box()
		print("Detected action")

func _init_prompt_box() -> void:
	_prompt_box = prompt_scene.instantiate()
	_prompt_box.pinner.manager = self
	_prompt_box.requester = ai_requester
	_prompting = true
	
	_prompt_box.sended.connect(_on_send_prompt)
	add_child(_prompt_box)

func _on_send_prompt() -> void:
	_prompting = false
	_prompt_box = null

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

func get_screen_info(id: String) -> void:
	
	var window: Window = get_window()
	
	var screen_id := DisplayServer.window_get_current_screen(window.get_window_id())
	
	var screen_size := DisplayServer.screen_get_size(screen_id)
	
	var message_content: Dictionary[String, Variant] = {
		"screen_size": {
			"width": screen_size.x,
			"height": screen_size.y
		},
		"pet_position": {
			"x": desktop_position.x,
			"y": desktop_position.y
		}
	}
	
	ai_requester.api.add_message(
		AIToolMessage.create(
			AIMessage.Role.TOOL,
			JSON.stringify(message_content),
			id
		)
	)
	
	ai_requester.retry_request()

func move_to(x: int, y: int, answer_action: bool, id: String) -> void:
	
	_target_position = Vector2i(x, y)
	var window: Window = get_window()
	
	var screen_id := DisplayServer.window_get_current_screen(window.get_window_id())
	
	var screen_size := DisplayServer.screen_get_size(screen_id)
	var size := DisplayServer.window_get_size(window.get_window_id())
	
	var pre_target_position := Vector2i(x+int(size.x/2.0), y+int(size.y/2.0))
	
	if pre_target_position > screen_size:
		ai_requester.api.add_message(
			AIMessage.create(
				AIMessage.Role.TOOL,
				"The coordinates are larger than the current screen."
			)
		)
	
	elif pre_target_position < Vector2i.ZERO:
		ai_requester.api.add_message(
			AIMessage.create(
				AIMessage.Role.TOOL,
				"The coordinates are lowest than Vector2i(0, 0)."
			)
		)
	
	else:
	
		_target_position = pre_target_position
		
		ai_requester.api.add_message(
			AIToolMessage.create(
				AIMessage.Role.TOOL,
				"Moving the character to the specified coordinates",
				id
			)
		)
	
	if answer_action:
		
		ai_requester.api.add_message(
			AIToolMessage.create(
				AIMessage.Role.TOOL,
				"""--- SYSTEM MESSAGE
				If the user asked you to move,
				and the action has already been performed,
				do not move again; instead, provide a response.
				---
				""",
				id
			)
		)
		
		ai_requester.retry_request()

func _on_tool_called(tool: AIToolCall) -> void:
	
	if not has_method(tool.function.name):
		return
	
	var args: Array = _make_args_array(tool.function.name, tool.function.arguments)
	
	if args == null:
		return
	
	args.append(tool.id)
	callv(tool.function.name, args)

## Returns Array or Variant
func _make_args_array(method_name: StringName, args: Dictionary) -> Variant:
	
	for method: Dictionary in get_method_list():
		
		if method.name != method_name:
			continue
		
		var ordered: Array = []
		
		for arg: Dictionary in method.args:
			
			if not args.has(arg.name):
				push_warning(
					"The dictionary %s don't have the parameter %s" % [JSON.stringify(args), arg.name]
				)
				continue
			
			ordered.append(args[arg.name])
		
		return ordered
	
	return null

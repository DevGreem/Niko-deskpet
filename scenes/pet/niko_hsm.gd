extends LimboHSM

class_name NikoHSM

@export var _start_state: LimboState

func _ready() -> void:
	initial_state = _start_state

extends Resource

class_name DialogueMessage

@export var icon: String
@export var message: String

func _init(_message := "", _icon := "") -> void:
	self.message = _message
	self.icon = _icon

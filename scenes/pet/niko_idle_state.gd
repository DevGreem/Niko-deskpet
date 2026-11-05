extends LimboState

class_name NikoIdleState

@export var moving_state: LimboState
@export var anim_sprite: AnimatedSprite2D

var actor: PetNode:
	get: return agent as PetNode

var root: LimboHSM:
	get: return get_root()

const MOVE_TRANSITION := "MOVE"

func _enter() -> void:
	root.add_transition(self, moving_state, MOVE_TRANSITION)
	anim_sprite.play("default")

func _update(delta: float) -> void:
	
	if actor._target_position != actor.desktop_position and actor._target_position != -Vector2i.ONE:
		dispatch(MOVE_TRANSITION)
		return

func _exit() -> void:
	root.remove_transition(self, MOVE_TRANSITION)

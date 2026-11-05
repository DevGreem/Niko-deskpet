extends LimboState

class_name NikoMovingState

@export var idle_state: LimboState
@export var anim_sprite: AnimatedSprite2D

var actor: PetNode:
	get: return agent as PetNode

var root: LimboHSM:
	get: return get_root()

const IDLE_TRANSITION := "IDLE"

func _enter() -> void:
	root.add_transition(self, idle_state, IDLE_TRANSITION)

func _update(delta: float) -> void:
	
	if actor._target_position == actor.desktop_position or actor._target_position == Vector2i.ONE:
		dispatch(IDLE_TRANSITION)
		return
	
	var direction := Vector2(actor.desktop_position).direction_to(Vector2(actor._target_position))
	var movement := direction * actor.speed * delta
	
	var window := get_window()
	var window_pos := Vector2(DisplayServer.window_get_position(window.get_window_id()))
	
	window_pos += movement
	
	DisplayServer.window_set_position(Vector2i(window_pos), window.get_window_id())
	_set_animation(direction)

func _set_animation(direction: Vector2) -> void:
	
	if abs(direction.x) > abs(direction.y):
		
		if direction.x > 0:
			anim_sprite.play("walk_right")
		else:
			anim_sprite.play("walk_left")
	else:
		
		if direction.y > 0:
			anim_sprite.play("walk_down")
		else:
			anim_sprite.play("walk_up")

func _exit() -> void:
	actor._target_position = -Vector2i.ONE
	root.remove_transition(self, IDLE_TRANSITION)

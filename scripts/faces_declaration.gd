@tool
extends Resource

class_name FacesDeclaration

@export var non_exists_face: Texture2D = PlaceholderTexture2D.new()

@export var _faces_container: Dictionary[Vector2i, String] = {}:
	set(value):
		
		_faces_container = value
		
		_string_faces_container.clear()
		for key: Vector2i in _faces_container:
			_string_faces_container[_faces_container[key]] = key

var faces: Array[String]:
	get: return _faces_container.values()

var faces_position: Array[Vector2i]:
	get: return _faces_container.keys()

var _string_faces_container: Dictionary[String, Vector2i] = {}

func get_face_title(pos: Vector2i) -> String:
	return _faces_container.get(pos, "")

func get_face_pos(title: String) -> Vector2i:
	return _string_faces_container.get(title, -Vector2i.ONE)

func declare_face(pos: Vector2i, title: String) -> void:
	_faces_container[pos] = title
	_string_faces_container[title] = pos

func undeclare_face_by_pos(pos: Vector2i) -> bool:
	var title := str(_faces_container.get(pos), "")
	
	if not title:
		return false
	
	_faces_container.erase(pos)
	_string_faces_container.erase(title)
	return true

func undeclare_face_by_title(title: String) -> bool:
	var pos := Vector2i(_string_faces_container.get(title, -Vector2i.ONE))
	
	if pos == -Vector2i.ONE:
		return false
	
	_string_faces_container.erase(title)
	_faces_container.erase(pos)
	return true

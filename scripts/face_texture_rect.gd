@tool
extends SpriteSheetRect

class_name FaceTextureRect

@export var faces_declaration := FacesDeclaration.new()

@export var face: String:
	get:
		
		if not faces_declaration:
			return ""
		
		return faces_declaration.get_face_title(atlas_position)
	set(value):
		atlas_position = faces_declaration.get_face_pos(value)

var _texture_backup: AtlasTexture = null

func _update_atlas_position() -> void:
	
	if self.texture != faces_declaration.non_exists_face:
		_texture_backup = self.texture
	
	if atlas_position == -Vector2i.ONE:
		
		texture = faces_declaration.non_exists_face
		return
	
	self.texture = _texture_backup
	super._update_atlas_position()

func _validate_property(property: Dictionary) -> void:
	
	super._validate_property(property)
	
	if property.name == "face":
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = ",".join(faces_declaration.faces)

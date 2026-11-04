@tool
extends TextureRect

class_name SpriteSheetRect

var rows: int = 1
var columns: int = 1

var atlas_position := Vector2i.ZERO:
	set(value):
		
		atlas_position = value
		_update_atlas_position()

func _update_atlas_position() -> void:
	
	var atlas: AtlasTexture = self.texture
	
	atlas.region.position.x = atlas.region.size.x * atlas_position.x
	atlas.region.position.y = atlas.region.size.y * atlas_position.y

func _validate_property(property: Dictionary) -> void:
	
	if property.name == "texture":
		property.hint_string = "AtlasTexture"

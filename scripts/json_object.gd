@abstract
extends Resource

class_name JsonObject

@abstract
func to_dict() -> Dictionary[String, Variant]

func from_dict(dict: Dictionary, set_objects := false) -> void:
	
	var obj_props: Dictionary[String, Dictionary] = {}
	
	for prop: Dictionary in get_property_list():
		
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			obj_props[prop.name] = prop
	
	for param: String in dict:
		
		if not obj_props.has(param):
			continue
		
		var info: Dictionary = obj_props[param]
		var value: Variant = dict[param]
		
		## Not added
		if dict[param] is Dictionary and info.type == TYPE_OBJECT and set_objects:
			
			var str_class: String = info.get("class_name", "")
			
			if str_class.is_empty():
				continue
			
			var param_class: Object = _init_class_by_name(str_class)
			
			if param_class is JsonObject:
				param_class.from_dict(value as Dictionary, set_objects)
				self[param] = param_class
				continue
			
			self[param] = value
			continue
		
		self[param] = value

func _init_class_by_name(name: String) -> Object:
	
	if not ClassDB.class_exists(name):
		return null
	
	return ClassDB.instantiate(name)

@abstract
extends Resource

class_name JsonObject

@abstract
func to_dict() -> Dictionary[String, Variant]

func from_dict(dict: Dictionary, to_set_objects := Callable()) -> void:
	
	for param: String in dict:
		
		## Not added
		if dict[param] is Dictionary and not to_set_objects.is_null():
			to_set_objects.call(dict[param])
			continue
		
		self[param] = dict[param]

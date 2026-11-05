extends Resource

class_name UserConfig

const PATH := "user://config.tres"

@export var provider_url: String = ""
@export_storage var ai_token: String = ""
@export var model: String = ""

static func load_res() -> UserConfig:
	
	if not ResourceLoader.exists(PATH):
		var config := UserConfig.new()
		config.provider_url = "https://ai.hackclub.com/proxy/v1/chat/completions"
		config.model = "deepseek/deepseek-v4.1-flash"
		config.save()
		print("Loaded and saved config")
		return config
	
	print("Loaded config")
	return ResourceLoader.load(PATH)

func save() -> void:
	var error := ResourceSaver.save(self, PATH)
	
	if error == OK:
		print("Saved config")
	else:
		print("Error on save config")

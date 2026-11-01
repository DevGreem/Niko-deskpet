extends Resource

class_name UserConfig

const PATH := "user://config.tre"

var ai_token: String = ""
var model: String = ""

static func load() -> UserConfig:
	return ResourceLoader.load(PATH)

static func save(config: UserConfig):
	ResourceSaver.save(config, PATH)

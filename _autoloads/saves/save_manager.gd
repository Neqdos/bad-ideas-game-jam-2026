extends Node

const SETTINGS_PATH: String = "user://settings.tres"

var settings: SettingsResource

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	if FileAccess.file_exists(SETTINGS_PATH):
		settings = ResourceLoader.load(SETTINGS_PATH)
	else:
		settings = SettingsResource.new()
	
	settings.apply()

func save_settings() -> void:
	ResourceSaver.save(settings, SETTINGS_PATH)

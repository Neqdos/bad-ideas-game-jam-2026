extends Resource
class_name SettingsResource

@export var fullscreen: bool = false
@export var vsync: bool = true
@export var max_fps: int = 7
@export var master_volume: float = .5
@export var sfx_volume: float = .6
@export var music_volume: float = .5

const DEFAULT_SENSITIVITY: float = .01
@export var sensitivity: float = DEFAULT_SENSITIVITY

const MAX_FPS_VALUES: Array[int] = [
	30, 60, 75, 120, 144, 165, 240, 0,
]


func apply() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = MAX_FPS_VALUES[max_fps]
	
	AudioServer.set_bus_volume_linear(0, master_volume)
	AudioServer.set_bus_volume_linear(1, sfx_volume)
	AudioServer.set_bus_volume_linear(2, music_volume)

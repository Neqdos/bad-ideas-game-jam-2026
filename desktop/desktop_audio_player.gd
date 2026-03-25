extends AudioStreamPlayer3D
class_name DesktopAudioPlayer

@export var looping: bool = false

const MAX_DISTANCE: float = 8.0

func _ready() -> void:
	max_distance = MAX_DISTANCE
	
	if looping: finished.connect(func(): play())
	
	await get_tree().process_frame
	
	global_position = DesktopManager.sound_pos

func mute() -> void:
	volume_linear = 0.0

func unmute() -> void:
	volume_linear = 1.0

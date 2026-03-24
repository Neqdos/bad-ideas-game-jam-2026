extends AudioStreamPlayer3D
class_name DesktopAudioPlayer

@export var looping: bool = false

const MAX_DISTANCE: float = 5.0

func _ready() -> void:
	max_distance = MAX_DISTANCE
	#add_to_group("desktop_audio_player")
	
	if looping: finished.connect(func(): play())
	
	await get_tree().process_frame
	
	global_position = DesktopManager.sound_pos

func mute() -> void:
	volume_linear = 0.0

func unmute() -> void:
	volume_linear = 1.0

extends StaticBody3D
class_name WindowDoor

@onready var window_body: StaticBody3D = %WindowBody
@onready var break_glass_sound: AudioStreamPlayer3D = %BreakGlassSound

var broken: bool = false


func destroy_window() -> void:
	if broken: return
	broken = true
	window_body.queue_free()
	break_glass_sound.play()

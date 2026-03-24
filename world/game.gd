extends Node3D

@export var pc: PCObject
@export var player: PlayerBody

@onready var ambient_sound: AudioStreamPlayer = %AmbientSound

func _ready() -> void:
	pc.object_interact_action.interacted.emit(player)
	ambient_sound.finished.connect(func(): ambient_sound.play())

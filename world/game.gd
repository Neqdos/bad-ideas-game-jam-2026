extends Node3D

@export var pc: PCObject
@export var player: PlayerBody

func _ready() -> void:
	pc.object_interact_action.interacted.emit(player)

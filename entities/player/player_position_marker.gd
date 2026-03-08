extends Node3D
class_name PlayerPositionMarker


const HELD_OBJECT_LERP_SPEED: float = 20.0

var player: PlayerBody

func _physics_process(delta: float) -> void:
	global_position = player.global_position
	
	if !is_instance_valid(player.inv_manager.held_object): return
	
	player.inv_manager.held_object.global_transform = lerp(player.inv_manager.held_object.global_transform, player.hand.global_transform, delta * HELD_OBJECT_LERP_SPEED)

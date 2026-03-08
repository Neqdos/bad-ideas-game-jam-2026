extends Node
class_name InventoryManager

signal held_object_changed()

@export var player: PlayerBody

var is_inventory_ready: bool = false

var held_object: RigidObject:
	set(val):
		held_object = val
		held_object_changed.emit()


var objects_node: Node3D: get = _get_objects_node
func _get_objects_node() -> Node3D:
	if is_instance_valid(objects_node):
		return objects_node
	else:
		objects_node = get_tree().get_first_node_in_group("objects_node")
		return objects_node


func hold_object(object: RigidObject) -> void:
	if is_instance_valid(held_object):
		var previously_held_object: RigidObject = held_object
		unhold_object()
		StorageMethods.drop_object(previously_held_object, player.player_interaction_ray.global_position, player)
	
	object.hold_owner = player
	object.freeze = true
	object.global_transform = player.hand.global_transform
	object.set_collision_layer_value(4, false)
	object.reparent(player.player_position_marker)
	
	await get_tree().process_frame
	held_object = object

func unhold_object() -> void:
	if !is_instance_valid(held_object): return
	held_object.freeze = false
	held_object.set_collision_layer_value(4, true)
	held_object.hold_owner = null
	held_object.reparent(objects_node)
	held_object = null

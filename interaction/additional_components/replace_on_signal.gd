extends Node
class_name ReplaceOnSignal

@export var signal_name: String

@export var object_resource: ObjectResource

@export var object: RigidObject

@export var saved_properties: Dictionary[Node, String]

func _ready() -> void:
	get_parent().connect(signal_name, _replace)

func _replace() -> void:
	var new_object: RigidObject = load(object_resource.object_scene).instantiate()
	object.add_sibling(new_object)
	
	new_object.global_transform = object.global_transform
	
	for node: Node in saved_properties:
		var same_node: Node = new_object.find_child(node.name)
		same_node.set(saved_properties[node], node.get(saved_properties[node]))
	
	if is_instance_valid(object.hold_owner):
		var old_hold_owner: PlayerBody = object.hold_owner
		old_hold_owner.inv_manager.unhold_object()
		old_hold_owner.inv_manager.hold_object(new_object)
	elif is_instance_valid(object.grab_owner):
		object.grab_owner.player_interaction_ray.interactable = new_object
		object.grab_owner.player_interaction_ray.grabbed_object = new_object
		
	object.queue_free.call_deferred()

extends RayCast3D
class_name InteractionRay

@export var player: PlayerBody

signal hovered()
signal unhovered()


signal object_grabbed()
signal object_ungrabbed(previously_grabbed_object: RigidBody3D)

var grabbed_object: RigidBody3D:
	set(val):
		var previously_grabbed_object: RigidBody3D = grabbed_object
		grabbed_object = val
		
		if is_instance_valid(val):
			object_grabbed.emit()
		else:
			object_ungrabbed.emit(previously_grabbed_object)
			interactable = null

var blacklist: Array[Node]

func _ready() -> void:
	object_grabbed.connect(_on_object_grabbed)
	object_ungrabbed.connect(_on_object_ungrabbed)
	
	SignalManager.add_node_to_interaction_ray_blacklist.connect(_on_add_node_to_blacklist)
	SignalManager.remove_node_from_interaction_ray_blacklist.connect(_on_remove_node_from_blacklist)

func _on_object_grabbed() -> void:
	if grabbed_object is RigidObject:
		grabbed_object.grab_owner = player

func _on_object_ungrabbed(previously_grabbed_object: RigidBody3D) -> void:
	if !is_instance_valid(previously_grabbed_object): return
	if previously_grabbed_object is RigidObject:
		if previously_grabbed_object.grab_owner != player: return
		previously_grabbed_object.grab_owner = null

func _on_add_node_to_blacklist(node: Node, ray: InteractionRay) -> void:
	if ray != self: return
	
	blacklist.append(node)

func _on_remove_node_from_blacklist(node: Node, ray: InteractionRay) -> void:
	if ray != self: return
	
	blacklist.erase(node)


var interactable: Node3D = null: set = _set_interactable
func _set_interactable(val) -> void:
	if is_instance_valid(interactable):
		if interactable.tree_exited.is_connected(_on_interactable_tree_exited):
			interactable.tree_exited.disconnect(_on_interactable_tree_exited)
	
	interactable = val
	
	if is_instance_valid(interactable):
		hovered.emit()
		interactable.tree_exited.connect(_on_interactable_tree_exited)
	else:
		unhovered.emit()

var object: RigidObject:
	get():
		if !is_instance_valid(interactable): return null
		return interactable as RigidObject



func _on_interactable_tree_exited() -> void:
	interactable = null

func _physics_process(delta: float) -> void:
	if is_instance_valid(grabbed_object): return
	
	if is_colliding():
		var collider: Node3D = get_collider()
		
		
		if blacklist.has(collider):
			if interactable == collider: interactable = null
			return
		
		if interactable == collider: return
		
		interactable = collider
	else:
		if !is_instance_valid(interactable): return
		
		interactable = null

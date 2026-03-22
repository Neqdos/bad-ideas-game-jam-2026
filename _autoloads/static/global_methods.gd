extends Node
class_name  GlobalMethods

const hotbar_keys: Array[Key] = [
	KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0
]


static func get_direction_from_node3d(node3d: Node3D) -> Vector3:
	var direction: Vector3 = -node3d.global_basis.z * Vector3(1.0, 0.0, 1.0)
	direction = direction.normalized()
	return direction

static func find_first_child_of_type(parent: Node, type: Variant) -> Node:
	for child: Node in parent.get_children():
		if is_instance_of(child, type):
			return child
	return null

static func find_first_parent_of_type(parent: Node, type: Variant, stop_node: Node = null) -> Node:
	if !is_instance_valid(parent.get_parent()): return null
	if is_instance_valid(stop_node) and parent == stop_node: return null
	if is_instance_of(parent, type): return parent
	return find_first_parent_of_type(parent.get_parent(), type, stop_node)

static func get_correct_meshes_from_a_node(node: Node3D) -> Array[MeshInstance3D]:
	var meshes: Array[MeshInstance3D]
	
	for mi3d: MeshInstance3D in node.find_children("", "MeshInstance3D"):
		meshes.append(mi3d)
	
	return meshes

static func get_merged_aabb_from_meshes(meshes: Array[MeshInstance3D]) -> AABB:
	var aabb: AABB = AABB()
	
	for mi3d: MeshInstance3D in meshes:
		var mesh_aabb: AABB = mi3d.get_aabb()
		aabb = aabb.merge(AABB(mi3d.position - mesh_aabb.size / 2.0, mesh_aabb.size))
	return aabb

static func get_correct_collisions_from_a_node(node: Node3D) -> Array[CollisionShape3D]:
	var colls: Array[CollisionShape3D]
	
	for coll: CollisionShape3D in node.find_children("", "CollisionShape3D"):
		colls.append(coll)
	
	return colls

static func get_merged_aabb_from_collisions(colls: Array[CollisionShape3D]) -> AABB:
	var aabb: AABB = AABB()
	
	for coll: CollisionShape3D in colls:
		var shape: Shape3D = coll.shape
		var coll_aabb: AABB = AABB()
		
		if shape is BoxShape3D:
			coll_aabb = AABB(coll.position - shape.size / 2.0, shape.size)
		elif shape is ConvexPolygonShape3D:
			for p: Vector3 in shape.points:
				coll_aabb.expand(p)
		elif shape is CylinderShape3D:
			coll_aabb = AABB(coll.position, Vector3(shape.radius * 2.0, shape.height, shape.radius * 2.0))
		
		aabb = aabb.merge(AABB(coll.position - coll_aabb.size / 2.0, coll_aabb.size))
	return aabb

static func create_sleep_area_of_influence(position: Vector3, size: Vector3, parent: Node) -> void:
	var area: SleepAreaOfInfluence = SleepAreaOfInfluence.new()
	area.size = size * 1.2
	parent.add_child(area)
	area.global_position = position

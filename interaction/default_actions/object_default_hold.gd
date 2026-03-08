extends Node
class_name ObjectDefaultHold

@export var player: PlayerBody

const POSITION_PLACE_OFFSET: Vector3 = Vector3(0, .03, 0)


func _ready() -> void:
	player.input.object_hold.connect(_on_object_hold)

func _on_object_hold() -> void:
	if is_instance_valid(player.inv_manager.held_object):
		player.player_interaction_ray.force_raycast_update()
		
		if player.player_interaction_ray.is_colliding():
			place_object()
			player.inv_manager.unhold_object()
		else:
			StorageMethods.drop_object(player.inv_manager.held_object, player.player_interaction_ray.global_position, player)
			player.inv_manager.unhold_object()
		return
	
	if !is_instance_valid(player.player_interaction_ray.object): return
	
	player.inv_manager.hold_object(player.player_interaction_ray.object)


func place_object() -> void:
	var object: RigidObject = player.inv_manager.held_object
	var object_basis: Basis = Basis.looking_at(GlobalMethods.get_direction_from_node3d(player.player_interaction_ray))
	
	var target_point: Vector3 = player.player_interaction_ray.get_collision_point()
	var collision_normal: Vector3 = player.player_interaction_ray.get_collision_normal()
	
	#HACK: Probably should be changed to collisions instead of mesh.
	var aabb: AABB = GlobalMethods.get_merged_aabb_from_meshes(GlobalMethods.get_correct_meshes_from_a_node(object))
	
	var size_length: float = aabb.size.length() / 3
	
	var move_direction: Vector3 = -collision_normal * size_length
	var object_transform: Transform3D = Transform3D(object_basis, target_point - move_direction)
	
	var collision = KinematicCollision3D.new()
	
	var has_collision = object.test_move(object_transform, move_direction, collision)
	
	if has_collision:
		var travel: Vector3 = collision.get_travel()
		
		var actual_position_offset: Vector3 = POSITION_PLACE_OFFSET if collision_normal.y >= 0 else -POSITION_PLACE_OFFSET 
		object_transform.origin += travel + actual_position_offset
	
	object.global_transform = object_transform

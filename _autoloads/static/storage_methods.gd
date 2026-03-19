extends Node
class_name StorageMethods

const PLAYER_SIZE_Y: float = 1.85

const THROW_STRENGTH: float = 4.0
const THROW_ANGULAR_ROTATION: float = 4.0

const DROP_OFFSET: Vector3 = Vector3 (0, .2, 0)


static func throw_object(object: RigidObject, throw_direction: Vector3, from: Vector3 = Vector3.ZERO) -> void:
	if from: object.global_position = from
	
	var impulse: Vector3 = throw_direction * THROW_STRENGTH
	object.apply_central_impulse(impulse)
	
	var flat_direction: Vector2 = Vector2(throw_direction.x, throw_direction.z).normalized()
	
	var rand_x: float = (randf() * 2.0 - 1.0)
	var rand_z: float = (randf() * 2.0 - 1.0)
	var rand_torque_impulse = Vector3(rand_x, 0.0, rand_z).normalized()
	rand_torque_impulse = rand_torque_impulse.rotated(Vector3(0, 1, 0), -flat_direction.angle())
	object.angular_velocity = rand_torque_impulse * THROW_ANGULAR_ROTATION

static func drop_object(object: RigidObject, from: Vector3, used_node3d_direction: Node3D = null) -> void:
	var object_basis: Basis = Basis.IDENTITY
	
	if is_instance_valid(used_node3d_direction):
		object_basis = Basis.looking_at(GlobalMethods.get_direction_from_node3d(used_node3d_direction))
	
	var object_transform: Transform3D = Transform3D(object_basis, from)
	
	var target_direction = Vector3(0, -PLAYER_SIZE_Y, 0)
	
	var collision = KinematicCollision3D.new()
	var has_collision = object.test_move(object_transform, target_direction, collision)
	
	if has_collision:
		object_transform.origin += collision.get_travel() + DROP_OFFSET
	else:
		object_transform.origin += target_direction + DROP_OFFSET
	
	object.global_transform = object_transform

extends Area3D
class_name SleepAreaOfInfluence

var size: Vector3

func _ready() -> void:
	var collision_shape: CollisionShape3D = CollisionShape3D.new()
	var box_shape: BoxShape3D = BoxShape3D.new()
	box_shape.size = size
	collision_shape.shape = box_shape
	add_child(collision_shape)
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(4, true)
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	check_for_objects()

func check_for_objects() -> void:
	for body: Node3D in get_overlapping_bodies():
		if body is RigidBody3D:
			body.sleeping = false
	
	queue_free.call_deferred()

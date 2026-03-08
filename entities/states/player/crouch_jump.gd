extends State

@export var player: PlayerBody
@export var head: Node3D

@onready var collision_shape: CollisionShape3D = %PlayerCollisionShape

@onready var DEFAULT_CROUCH_HEIGHT: float = collision_shape.shape.height


func enter() -> void:
	collision_shape.shape.height = DEFAULT_CROUCH_HEIGHT - player.CROUCH_HEIGHT_DIFFERENCE
	collision_shape.position.y = collision_shape.shape.height / 2
	
	if player.is_on_floor():
		player.velocity.y = player.JUMP_POWER
	elif state_machine.current_state.type != "crouch":
		var result: KinematicCollision3D = KinematicCollision3D.new()
		player.test_move(player.global_transform, Vector3(0, player.CROUCH_JUMP_ADD, 0), result)
		player.position.y += result.get_travel().y
		head.position.y -= result.get_travel().y

func exit() -> void:
	if state_machine.current_state.type == "crouch": return
	
	collision_shape.shape.height = DEFAULT_CROUCH_HEIGHT
	collision_shape.position.y = collision_shape.shape.height / 2
	
	var result: KinematicCollision3D = KinematicCollision3D.new()
	player.test_move(player.global_transform, Vector3(0, -player.CROUCH_JUMP_ADD, 0), result)
	player.position.y += result.get_travel().y
	head.position.y -= result.get_travel().y

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		if player.input.input_vector:
			state_machine.change_state("crouchwalk")
		else:
			state_machine.change_state("crouch")
	
	if player.input.input_vector:
		var direction: Vector3 = player.transform.basis * Vector3(player.input.input_vector.x, 0.0 ,player.input.input_vector.y).normalized()
		
		player.velocity.x = lerpf(player.velocity.x, direction.x * player.SPEED * player.speed_multiplayer, player.IN_AIR_ACCELERATION * delta)
		player.velocity.z = lerpf(player.velocity.z, direction.z * player.SPEED * player.speed_multiplayer, player.IN_AIR_ACCELERATION * delta)

func update(_delta: float) -> void:
	if !player.input.is_crouching and !player.test_move(player.global_transform, Vector3(0, player.CROUCH_HEIGHT_DIFFERENCE, 0)):
		state_machine.change_state("falling")

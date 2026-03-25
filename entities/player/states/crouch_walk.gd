extends State

@export var player: PlayerBody

@onready var collision_shape: CollisionShape3D = %PlayerCollisionShape

@onready var DEFAULT_CROUCH_HEIGHT: float = collision_shape.shape.height

func enter() -> void:
	move(get_physics_process_delta_time())
	
	collision_shape.shape.height = DEFAULT_CROUCH_HEIGHT - player.CROUCH_HEIGHT_DIFFERENCE
	collision_shape.position.y = collision_shape.shape.height / 2

func exit() -> void:
	if state_machine.current_state.type == "crouch": return
	
	collision_shape.shape.height = DEFAULT_CROUCH_HEIGHT
	collision_shape.position.y = collision_shape.shape.height / 2

func physics_update(delta: float) -> void:
	move(delta)
	if !player.is_on_floor():
		state_machine.change_state("crouchjump")

func move(delta: float) -> void:
	var direction: Vector3 = player.transform.basis * Vector3(player.input.input_vector.x, 0.0 , player.input.input_vector.y).normalized()
	
	player.velocity.x = lerpf(player.velocity.x, direction.x * player.CROUCH_SPEED * player.speed_multiplayer, player.ACCELERATION * delta)
	player.velocity.z = lerpf(player.velocity.z, direction.z * player.CROUCH_SPEED * player.speed_multiplayer, player.ACCELERATION * delta)

func update(_delta: float) -> void:
	if !player.input.input_vector:
		state_machine.change_state("crouch")
	if !player.input.is_crouching and !player.test_move(player.global_transform, Vector3(0, player.CROUCH_HEIGHT_DIFFERENCE * DesktopManager.reversed_gravity_strength, 0)):
		state_machine.change_state("walk")
	elif player.input.just_jumped:
		state_machine.change_state("crouchjump")

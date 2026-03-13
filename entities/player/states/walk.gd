extends State

@export var player: PlayerBody


func enter() -> void:
	physics_update(get_physics_process_delta_time())

func physics_update(delta: float) -> void:
	var direction: Vector3 = player.transform.basis * Vector3(player.input.input_vector.x, 0.0 , player.input.input_vector.y).normalized()
	
	player.velocity.x = lerpf(player.velocity.x, direction.x * player.SPEED * player.speed_multiplayer, player.ACCELERATION * delta)
	player.velocity.z = lerpf(player.velocity.z, direction.z * player.SPEED * player.speed_multiplayer, player.ACCELERATION * delta)
	
	if !player.is_on_floor(): 
		state_machine.change_state("falling")

func update(_delta: float) -> void:
	if !player.input.input_vector:
		state_machine.change_state("idle")
	elif player.input.is_running:
		state_machine.change_state("run")
	elif player.input.just_jumped:
		state_machine.change_state("jump")
	elif player.input.is_crouching:
		state_machine.change_state("crouchwalk")

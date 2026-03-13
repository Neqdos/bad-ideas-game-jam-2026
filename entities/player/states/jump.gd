extends State

@export var player: PlayerBody

func enter() -> void:
	player.velocity.y = player.JUMP_POWER

func physics_update(delta: float) -> void:
	if player.velocity.y <= 0.0:
		state_machine.change_state("falling")
	
	if player.is_on_floor():
		if player.input.input_vector:
			state_machine.change_state("walk")
		else:
			state_machine.change_state("idle")
		return
	
	if player.input.input_vector:
		var direction: Vector3 = player.transform.basis * Vector3(player.input.input_vector.x, 0.0 ,player.input.input_vector.y).normalized()
		
		player.velocity.x = lerpf(player.velocity.x, direction.x * player.SPEED * player.speed_multiplayer, player.IN_AIR_ACCELERATION * delta)
		player.velocity.z = lerpf(player.velocity.z, direction.z * player.SPEED * player.speed_multiplayer, player.IN_AIR_ACCELERATION * delta)

func update(delta: float) -> void:
	if player.input.is_crouching:
		state_machine.change_state("crouchjump")

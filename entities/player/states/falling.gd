extends State

@export var player: PlayerBody

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		if player.input.input_vector:
			state_machine.change_state("walk")
		else:
			state_machine.change_state("idle")
	
	if player.input.input_vector:
		var direction: Vector3 = player.transform.basis * Vector3(player.input.input_vector.x, 0.0 ,player.input.input_vector.y).normalized()
		
		player.velocity.x = lerpf(player.velocity.x, direction.x * player.SPEED * player.speed_multiplayer, player.IN_AIR_ACCELERATION * delta)
		player.velocity.z = lerpf(player.velocity.z, direction.z * player.SPEED * player.speed_multiplayer, player.IN_AIR_ACCELERATION * delta)


func update(_delta: float) -> void:
	if player.input.is_crouching and !DesktopManager.reversed_gravity:
		state_machine.change_state("crouchjump")

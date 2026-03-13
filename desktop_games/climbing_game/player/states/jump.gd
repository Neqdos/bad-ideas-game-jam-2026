extends State

@export var player: ClimbingPlayer

func enter() -> void:
	player.velocity.y = -player.JUMP_POWER
	player.jump_buffer_timer.stop()

func physics_update(delta: float) -> void:
	if player.velocity.y >= 0.0:
		state_machine.change_state("falling")
	
	if player.is_on_floor():
		if player.input.input_x:
			state_machine.change_state("walk")
		else:
			state_machine.change_state("idle")
		return
	
	player.velocity.x = lerpf(player.velocity.x, player.input.input_x * player.SPEED, (player.IN_AIR_ACCELERATION if player.input.input_x else player.ACCELERATION) * delta)

func update(delta: float) -> void:
	if player.input.jump_released:
		player.velocity.y *= .2

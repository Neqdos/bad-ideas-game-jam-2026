extends State

@export var player: ClimbingPlayer

func enter() -> void:
	player.gravity_scale = 1.75

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		if player.input.input_x:
			state_machine.change_state("walk")
		else:
			state_machine.change_state("idle")
	
	player.velocity.x = lerpf(player.velocity.x, player.input.input_x * player.SPEED, (player.IN_AIR_ACCELERATION if player.input.input_x else player.ACCELERATION) * delta)

func exit() -> void:
	player.gravity_scale = 1.0
	player.last_y_position = player.global_position.y

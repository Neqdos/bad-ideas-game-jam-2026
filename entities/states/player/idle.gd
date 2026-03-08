extends State

@export var player: PlayerBody


func update(delta: float) -> void:
	player.velocity.x = lerpf(player.velocity.x, 0.0, player.DECELERATION * delta)
	player.velocity.z = lerpf(player.velocity.z, 0.0, player.DECELERATION * delta)
	
	if player.input.input_vector:
		state_machine.change_state("walk")
	elif player.input.is_crouching:
		state_machine.change_state("crouch")
	elif player.input.just_jumped:
		state_machine.change_state("jump")

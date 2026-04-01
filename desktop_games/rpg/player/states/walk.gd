extends State

@export var player: RPGPlayer

func physics_update(delta: float) -> void:
	player.velocity = player.velocity.lerp(player.input.input_vector * player.SPEED, delta * player.ACCELERATION)

func update(delta: float) -> void:
	if !player.input.input_vector:
		state_machine.change_state("idle")

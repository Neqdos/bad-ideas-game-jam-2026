extends State

@export var player: RPGPlayer

func physics_update(delta: float) -> void:
	player.velocity = player.velocity.lerp(Vector2.ZERO, delta * player.DECELERATION)

func update(delta: float) -> void:
	if player.input.input_vector:
		state_machine.change_state("walk")

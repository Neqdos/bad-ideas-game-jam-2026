extends State

@export var player: RPGPlayer

func physics_update(delta: float) -> void:
	player.velocity = player.velocity.lerp(Vector2.ZERO, delta * player.DECELERATION)

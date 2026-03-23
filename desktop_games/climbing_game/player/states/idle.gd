extends State

@export var player: ClimbingPlayer

func enter() -> void:
	if is_node_ready(): return
	player.hook_uses = 0
	if player.jump_buffer_timer.time_left:
		state_machine.change_state("jump")

func physics_update(delta: float) -> void:
	player.velocity.x = lerpf(player.velocity.x, 0.0, player.DECELERATION * delta)

func update(delta: float) -> void:
	if player.input.input_x:
		state_machine.change_state("walk")
	elif player.jump_buffer_timer.time_left:
		state_machine.change_state("jump")
	elif player.input.grappling_hook_pressed:
		state_machine.change_state("hookshot")

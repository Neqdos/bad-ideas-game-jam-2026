extends State

@export var player: ClimbingPlayer


func enter() -> void:
	player.hook_uses = 0
	if player.jump_buffer_timer.time_left:
		state_machine.change_state("jump")

func physics_update(delta: float) -> void:
	player.velocity.x = lerpf(player.velocity.x, player.input.input_x * player.SPEED, player.ACCELERATION * delta)
	
	if !player.is_on_floor():
		state_machine.change_state("falling")
		player.koyote_timer.start()

func update(_delta: float) -> void:
	if !player.input.input_x:
		state_machine.change_state("idle")
	elif player.jump_buffer_timer.time_left:
		player.velocity.x *= 1.3
		state_machine.change_state("jump")
	elif player.input.grappling_hook_pressed:
		state_machine.change_state("hookshot")

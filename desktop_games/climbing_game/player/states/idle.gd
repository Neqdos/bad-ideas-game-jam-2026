extends State

@export var player: ClimbingPlayer

var initial_enter: bool = true

func enter() -> void:
	if initial_enter:
		initial_enter = false
		return
	
	player.hook_uses = 0
	
	await get_tree().process_frame
	
	if player.jump_buffer_timer.time_left:
		state_machine.change_state("jump")
		player.jump_buffer_timer.stop()

func physics_update(delta: float) -> void:
	player.velocity.x = lerpf(player.velocity.x, 0.0, player.DECELERATION * delta)

func update(delta: float) -> void:
	if player.input.input_x:
		state_machine.change_state("walk")
	elif player.jump_buffer_timer.time_left:
		state_machine.change_state("jump")
		player.jump_buffer_timer.stop()
	elif player.input.grappling_hook_pressed:
		state_machine.change_state("hookshot")

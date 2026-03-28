extends State

@export var player: ClimbingPlayer
@onready var jump_dust: GPUParticles2D = %JumpDust
@onready var animation_controller: AnimationController = %AnimationController

func enter() -> void:
	player.velocity.y = -player.JUMP_POWER
	
	var new_jump_dust: GPUParticles2D = jump_dust.duplicate()
	player.add_child(new_jump_dust)
	new_jump_dust.emitting = true
	new_jump_dust.finished.connect(new_jump_dust.queue_free)
	animation_controller.squish_y()
	
	player.koyote_timer.stop()
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
	elif player.input.just_jumped and DesktopManager.has_wings:
		state_machine.change_state("glide")
	elif player.input.grappling_hook_pressed and player.hook_uses == 0:
		state_machine.change_state("hookshot")

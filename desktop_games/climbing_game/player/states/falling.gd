extends State

@export var player: ClimbingPlayer
@onready var fall_dust: GPUParticles2D = %FallDust
@onready var animation_controller: AnimationController = %AnimationController

func enter() -> void:
	player.gravity_scale = 1.75

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		if player.input.input_x:
			state_machine.change_state("walk")
		else:
			state_machine.change_state("idle")
	
	player.velocity.x = lerpf(player.velocity.x, player.input.input_x * player.SPEED, (player.IN_AIR_ACCELERATION if player.input.input_x else player.ACCELERATION) * delta)

func update(delta: float) -> void:
	if player.input.grappling_hook_pressed and player.hook_uses == 0:
		state_machine.change_state("hookshot")

func exit() -> void:
	player.gravity_scale = 1.0
	player.last_y_position = player.global_position.y
	var new_fall_dust: GPUParticles2D = fall_dust.duplicate()
	player.add_child(new_fall_dust)
	new_fall_dust.emitting = true
	new_fall_dust.finished.connect(new_fall_dust.queue_free)
	animation_controller.squish_x()
	

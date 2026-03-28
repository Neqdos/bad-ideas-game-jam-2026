extends State

@export var player: ClimbingPlayer
@onready var wind_tiles_area: Area2D = %WindTilesArea

const GLIDING_MAX_GRAVITY_SCALE: float = .1
const WIND_MAX_GRAVITY_SCALE: float = -.5

func enter() -> void:
	player.max_gravty_scale = GLIDING_MAX_GRAVITY_SCALE

func physics_update(delta: float) -> void:
	if wind_tiles_area.has_overlapping_areas():
		player.max_gravty_scale = WIND_MAX_GRAVITY_SCALE
	else:
		player.max_gravty_scale = GLIDING_MAX_GRAVITY_SCALE
	
	player.velocity.x = lerpf(player.velocity.x, player.input.input_x * player.SPEED, (player.IN_AIR_ACCELERATION if player.input.input_x else player.ACCELERATION) * delta)
	
	if player.is_on_floor():
		if player.input.input_x:
			state_machine.change_state("walk")
		else:
			state_machine.change_state("idle")

func update(delta: float) -> void:
	if player.input.grappling_hook_pressed and player.hook_uses == 0:
		state_machine.change_state("hookshot")
	elif player.input.jump_released:
		state_machine.change_state("falling")

func exit() -> void:
	player.max_gravty_scale = 1.0
	

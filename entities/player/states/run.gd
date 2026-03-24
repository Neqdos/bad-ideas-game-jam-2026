extends State

@export var player: PlayerBody

const FOOTSTEP_TIMER: float = .25
var can_footstep: bool = true

func physics_update(delta: float) -> void:
	var direction: Vector3 = player.transform.basis * Vector3(player.input.input_vector.x, 0.0, player.input.input_vector.y).normalized()
	
	player.velocity.x = lerpf(player.velocity.x, direction.x * player.SPRINT_SPEED * player.speed_multiplayer, player.ACCELERATION * delta)
	player.velocity.z = lerpf(player.velocity.z, direction.z * player.SPRINT_SPEED * player.speed_multiplayer, player.ACCELERATION * delta)
	
	if !player.is_on_floor(): 
		state_machine.change_state("falling")

func update(_delta: float) -> void:
	if can_footstep:
		can_footstep = false
		player.footsteps_sound.play()
		await get_tree().create_timer(FOOTSTEP_TIMER).timeout
		can_footstep = true
	
	if !player.input.input_vector:
		state_machine.change_state("idle")
	elif !player.input.is_running:
		state_machine.change_state("walk")
	elif player.input.just_jumped:
		state_machine.change_state("jump")

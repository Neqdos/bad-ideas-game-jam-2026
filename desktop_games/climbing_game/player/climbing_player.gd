extends CharacterBody2D
class_name ClimbingPlayer

@export var input: ClimbingGameInput
@export var phantom_camera_host: PhantomCameraHost

@onready var koyote_timer: Timer = %KoyoteTimer
@onready var jump_buffer_timer: Timer = %JumpBufferTimer

@onready var state_machine: StateMachine = %StateMachine

@onready var death_particles: GPUParticles2D = %DeathParticles
@onready var animation_controller: AnimationController = %AnimationController

@onready var metal_block_above_raycast: RayCast2D = %MetalBlockAboveRaycast
@onready var ceiling_above_raycast: RayCast2D = %CeilingAboveRaycast
@onready var metal_block_below_raycast: RayCast2D = $MetalBlockBelowRaycast

const SPEED: float = 80.0
const ACCELERATION: float = 40.0
const IN_AIR_ACCELERATION: float = 8.0
const DECELERATION: float = 40.0
var acceleration_mult: float = 1.0

const JUMP_POWER: float = 160.0
const GRAVITY: float = 360.0
const MAX_GRAVITY: float = 300.0
var gravity_scale: float = 1.0
var max_gravty_scale: float = 1.0


var can_move: int = 0

var hook_uses: int = 0

var dead: bool = false

func _ready() -> void:
	input.jumped.connect(_on_jumped)
	input.restart.connect(_on_restart)
	
	DesktopManager.climbing_player_death.connect(_on_player_death)

func _physics_process(delta: float) -> void:
	if !dead:
		if is_on_floor() and metal_block_above_raycast.is_colliding():
			var collider = metal_block_above_raycast.get_collider()
			if collider is MetalBlock:
				DesktopManager.climbing_player_death.emit()
		elif metal_block_below_raycast.is_colliding() and ceiling_above_raycast.is_colliding():
			var collider = metal_block_below_raycast.get_collider()
			if collider is MetalBlock:
				DesktopManager.climbing_player_death.emit()
	
	if can_move > 0: return
	velocity.y += GRAVITY * gravity_scale * delta
	velocity.y = minf(MAX_GRAVITY * max_gravty_scale, velocity.y)
	
	move_and_slide()

func _on_jumped() -> void:
	if koyote_timer.time_left:
		state_machine.change_state("jump")
	else:
		jump_buffer_timer.start()

func _on_restart() -> void:
	if dead: return
	DesktopManager.climbing_player_death.emit()

func _on_player_death() -> void:
	dead = true
	DesktopManager.climbing_input_lock.emit(true)
	can_move += 1
	velocity = Vector2.ZERO
	
	animation_controller.visible = false
	var new_death_particles: GPUParticles2D = death_particles.duplicate()
	new_death_particles.finished.connect(new_death_particles.queue_free)
	add_child(new_death_particles)
	new_death_particles.emitting = true
	
	await new_death_particles.finished
	
	DesktopManager.climbing_transition.emit(true, .5)
	await DesktopManager.climbing_transition_finished
	
	animation_controller.visible = true
	
	respawn()
	
	await get_tree().create_timer(.1).timeout
	
	DesktopManager.climbing_transition.emit(false, .5)
	await DesktopManager.climbing_transition_finished
	
	DesktopManager.climbing_input_lock.emit(false)
	can_move -= 1
	dead = false

func respawn() -> void:
	var camera: PhantomCamera2D = phantom_camera_host.get_active_pcam()
	camera.priority = 0
	global_position = DesktopManager.climbing_spawn_area.global_position
	DesktopManager.climbing_spawn_area.camera.priority = 2

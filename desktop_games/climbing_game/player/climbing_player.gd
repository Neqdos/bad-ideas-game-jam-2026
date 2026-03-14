extends CharacterBody2D
class_name ClimbingPlayer

@export var input: ClimbingGameInput

@onready var koyote_timer: Timer = %KoyoteTimer
@onready var jump_buffer_timer: Timer = %JumpBufferTimer

@onready var state_machine: StateMachine = %StateMachine

const SPEED: float = 80.0
const ACCELERATION: float = 40.0
const IN_AIR_ACCELERATION: float = 8.0
const DECELERATION: float = 40.0
var acceleration_mult: float = 1.0

const JUMP_POWER: float = 160.0
const GRAVITY: float = 360.0
const MAX_GRAVITY: float = 300.0
var gravity_scale: float = 1.0

@onready var last_y_position: float = global_position.y

var can_move: bool = true

func _ready() -> void:
	input.jumped.connect(_on_jumped)
	
	DesktopManager.climbing_player_death.connect(_on_player_death)

func _physics_process(delta: float) -> void:
	if !can_move: return
	if velocity.y < MAX_GRAVITY:
		velocity.y += GRAVITY * gravity_scale * delta
	
	move_and_slide()

func _on_jumped() -> void:
	if koyote_timer.time_left:
		state_machine.change_state("jump")
		koyote_timer.stop()
	else:
		jump_buffer_timer.start()

func _on_player_death() -> void:
	DesktopManager.climbing_input_lock.emit(true)
	can_move = false
	velocity = Vector2.ZERO
	
	await get_tree().create_timer(DesktopManager.CLIMBING_DEATH_TIME).timeout
	
	DesktopManager.climbing_input_lock.emit(false)
	can_move = true
	respawn()

func respawn() -> void:
	global_position = DesktopManager.climbing_spawn_area.global_position
	DesktopManager.climbing_spawn_area.camera.priority = 2

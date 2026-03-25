extends CharacterBody3D
class_name PlayerBody

@export var inv_manager: InventoryManager
@export var player_interaction_ray: InteractionRay
@export var camera: FirstPersonCamera
@export var hand: Marker3D
var player_position_marker: PlayerPositionMarker

@export var state_machine: StateMachine

@export var input: PlayerInput
@onready var footsteps_sound: AudioStreamPlayer3D = %FootstepsSound
@onready var player_collision_shape: CollisionShape3D = %PlayerCollisionShape

const PLAYER_POSITION_MARKER_SCENE = preload("uid://cpclijfddba8j")

const SPEED: float = 3.0
const SPRINT_SPEED: float = 5.0
const CROUCH_SPEED: float = 1.0
var speed_multiplayer: float = 1.0

const JUMP_POWER: float = 5.0

const ACCELERATION: float = 8.0
const DECELERATION: float = 10.0
const IN_AIR_ACCELERATION: float = 1.5

const CROUCH_HEIGHT_DIFFERENCE: float = 1.0
const CROUCH_JUMP_ADD: float = CROUCH_HEIGHT_DIFFERENCE * .8

const GRAVITY: float = 16.0


func _ready() -> void:
	player_position_marker = PLAYER_POSITION_MARKER_SCENE.instantiate()
	player_position_marker.player = self
	add_sibling.call_deferred(player_position_marker)
	DesktopManager.gravity_changed.connect(_on_gravity_changed)

func _physics_process(delta: float) -> void:
	velocity.y -= GRAVITY * delta * DesktopManager.reversed_gravity_strength
	
	move_and_slide()

func _on_gravity_changed() -> void:
	rotation.z = 0.0 if !DesktopManager.reversed_gravity else PI
	global_position.y += -player_collision_shape.shape.height * DesktopManager.reversed_gravity_strength
	up_direction.y = DesktopManager.reversed_gravity_strength
	
	var result: KinematicCollision3D = KinematicCollision3D.new()
	test_move(global_transform, Vector3(0, -3.0 * DesktopManager.reversed_gravity_strength, 0), result)
	global_position.y += result.get_travel().y

extends CharacterBody3D
class_name PlayerBody

@export var inv_manager: InventoryManager
@export var player_interaction_ray: InteractionRay
@export var camera: FirstPersonCamera
@export var hand: Marker3D
var player_position_marker: PlayerPositionMarker

@export var state_machine: StateMachine

@export var input: PlayerInput

const PLAYER_POSITION_MARKER_SCENE = preload("uid://cpclijfddba8j")

const SPEED: float = 3.0
const SPRINT_SPEED: float = 7.0
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

func _physics_process(delta: float) -> void:
	velocity.y -= GRAVITY * delta
	
	move_and_slide()

extends Camera3D
class_name FirstPersonCamera

@export var head: Node3D
@export var player: CharacterBody3D
@export var player_state_machine: StateMachine

@onready var default_head_y_position: float = head.position.y
@onready var head_lerp_y_position: float = default_head_y_position
var head_lerp_xz_position: Vector2
var state_change_head_lerp_position: bool = true

const DEFAULT_FOV: float = 100.0

const HEAD_LERP_SPEED: float = 30.0

const MOVE_TILT: float = 4.0
const MOVE_BOB: float = 4.0
var move_bob_multiplier: float

const CAMERA_SMOOTHING: float = 15.0

var camera_rot_target: Vector2:
	set(val):
		camera_rot_target = val
		camera_rot_target.y = clampf(camera_rot_target.y, -PI / 2, PI / 2)

var player_rot_y: float

var camera_rot_offset: Vector2
var camera_rot_offset_sin: Vector2
var camera_rot_offset_sin_frequency: float

var time: float
var has_set_jump_move_bob_down: bool = false

var can_rotate: int = 0


func _ready() -> void:
	if is_multiplayer_authority(): current = true
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	player_state_machine.state_changed.connect(_on_state_changed)
	
	SignalManager.camera_lock.connect(_on_camera_lock)
	SignalManager.camera_position_at.connect(_on_camera_position_at)

func _on_camera_lock(is_locked: bool) -> void:
	can_rotate += int(is_locked) * 2 - 1
	can_rotate = max(0, can_rotate)

func _on_camera_position_at(marker_transform: Transform3D) -> void:
	if marker_transform:
		state_change_head_lerp_position = false
		
		var angle_y: float = Vector2(marker_transform.basis.z.y, marker_transform.basis.z.z).angle() - PI / 2.0
		var angle_x: float = -Vector2(marker_transform.basis.z.x, marker_transform.basis.z.z).angle() + PI / 2.0
		
		var abs_cam_rot_x: float = absf(camera_rot_target.x)
		var added_rotation: float = 0.0
		while abs_cam_rot_x > TAU:
			abs_cam_rot_x -= TAU
			added_rotation += TAU if camera_rot_target.x > 0.0 else -TAU
		
		camera_rot_target.y = angle_y
		camera_rot_target.x = added_rotation + angle_x
		head_lerp_y_position = marker_transform.origin.y
		head_lerp_xz_position = Vector2(marker_transform.origin.x, marker_transform.origin.z)
	else:
		state_change_head_lerp_position = true
		head.position.x = 0.0
		head.position.z = 0.0
		check_for_state_and_head_lerp_position()

func _on_state_changed() -> void:
	if !state_change_head_lerp_position: return
	check_for_state_and_head_lerp_position()

func check_for_state_and_head_lerp_position() -> void:
	var is_crouching: bool = player_state_machine.current_state.type == "crouch" or player_state_machine.current_state_name == "ledgeclimb"
	head_lerp_y_position = default_head_y_position if !is_crouching else default_head_y_position - player.CROUCH_HEIGHT_DIFFERENCE

func _physics_process(delta: float) -> void:
	time += delta * camera_rot_offset_sin_frequency
	
	check_for_state(delta)
	set_move_bob()
	
	# move tilt
	head.rotation.z = lerpf(head.rotation.z, deg_to_rad(-player.input.input_vector.x * MOVE_TILT), delta * 8.0)
	
	# camera/player rotations
	player_rot_y = lerpf(player_rot_y, camera_rot_target.x, CAMERA_SMOOTHING * delta)
	player.rotation.y = player_rot_y
	
	head.rotation.x = lerp_angle(head.rotation.x, camera_rot_target.y + camera_rot_offset.y, CAMERA_SMOOTHING * delta)
	head.rotation.y = lerp_angle(head.rotation.y, camera_rot_offset.x, CAMERA_SMOOTHING * delta)
	
	if state_change_head_lerp_position:
		head.position.y = lerpf(head.position.y, head_lerp_y_position, delta * HEAD_LERP_SPEED)
	else:
		head.global_position.y = lerpf(head.global_position.y, head_lerp_y_position, delta * HEAD_LERP_SPEED)
		head.global_position.x = lerpf(head.global_position.x, head_lerp_xz_position.x, delta * HEAD_LERP_SPEED)
		head.global_position.z = lerpf(head.global_position.z, head_lerp_xz_position.y, delta * HEAD_LERP_SPEED)

func check_for_state(delta: float) -> void:
	match player_state_machine.current_state_name:
		"jump", "falling":
			if has_set_jump_move_bob_down:
				camera_rot_offset.y = lerpf(camera_rot_offset.y, deg_to_rad(15.0), delta * player.JUMP_POWER)
			else:
				camera_rot_offset.y = deg_to_rad(-20)
			camera_rot_offset.x = lerp(camera_rot_offset.x, 0.0, delta)
			has_set_jump_move_bob_down = true
			return
		"run":
			move_bob_multiplier = .5
			camera_rot_offset_sin_frequency = 20.0
		"walk":
			move_bob_multiplier = .4
			camera_rot_offset_sin_frequency = 10.0
		"crouchwalk":
			move_bob_multiplier = .8
			camera_rot_offset_sin_frequency = 4.0
		_:
			move_bob_multiplier = .1
			camera_rot_offset_sin_frequency = 1.0
	has_set_jump_move_bob_down = false

func set_move_bob() -> void:
	camera_rot_offset_sin = Vector2(sin(time / 2), sin(time))
	
	camera_rot_offset = Vector2.ZERO
	camera_rot_offset.x = deg_to_rad(move_bob_multiplier * MOVE_BOB * camera_rot_offset_sin.x)
	camera_rot_offset.y = deg_to_rad(move_bob_multiplier * MOVE_BOB * camera_rot_offset_sin.y)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and can_rotate == 0 and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_rot_target.x += -event.relative.x * SaveManager.settings.sensitivity
		camera_rot_target.y += -event.relative.y * SaveManager.settings.sensitivity
	elif event.is_action_pressed("change_mouse_mode"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
	# FIXME: ^ get rid of change_mouse_mode later when publishing the game.

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
#var has_set_jump_move_bob_down: bool = false

var can_rotate: int = 0
var can_do_rot_offset: bool = true

var looked_at_object: Node3D = null

func _ready() -> void:
	if is_multiplayer_authority(): current = true
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	SignalManager.camera_lock.connect(_on_camera_lock)
	SignalManager.camera_position_at.connect(_on_camera_position_at)
	SignalManager.camera_look_at.connect(_on_camera_look_at)
	
	player_state_machine.state_changed.connect(_on_state_changed)

func _on_camera_lock(is_locked: bool) -> void:
	can_rotate += int(is_locked) * 2 - 1
	can_rotate = max(0, can_rotate)

func _on_camera_position_at(pos: Vector3) -> void:
	if pos:
		state_change_head_lerp_position = false
		
		#var angle_y: float = Vector2(marker_transform.basis.z.y, marker_transform.basis.z.z).angle() - PI / 2.0
		#var angle_x: float = -Vector2(marker_transform.basis.z.x, marker_transform.basis.z.z).angle() + PI / 2.0
		
		#var abs_cam_rot_x: float = absf(camera_rot_target.x)
		#var added_rotation: float = 0.0
		#while abs_cam_rot_x > TAU:
		#	abs_cam_rot_x -= TAU
		#	added_rotation += TAU if camera_rot_target.x > 0.0 else -TAU
		
		#camera_rot_target.y = angle_y
		#camera_rot_target.x = added_rotation + angle_x
		head_lerp_y_position = pos.y
		head_lerp_xz_position = Vector2(pos.x, pos.z)
		#camera_rot_offset = Vector2.ZERO
		#can_do_rot_offset = false
	else:
		state_change_head_lerp_position = true
		head.position.x = 0.0
		head.position.z = 0.0
		#can_do_rot_offset = true
		check_for_state_and_head_lerp_position()

func _on_camera_look_at(what: Node3D) -> void:
	looked_at_object = what
	can_do_rot_offset = is_instance_valid(what)

func look_at_object() -> void:
	var dir_to_obj: Vector3 = looked_at_object.global_position - global_position.normalized()
	var my_dir: Vector3 = global_basis.z
	var difference: Vector3 = (dir_to_obj - my_dir).normalized()
	
	var abs_rot: float = absf(camera_rot_target.x)
	while abs_rot > TAU: abs_rot -= TAU
	
	var is_less_than_half: bool = abs_rot < PI
	
	var offset: float = floorf(camera_rot_target.x / TAU) * TAU if is_less_than_half else ceilf(camera_rot_target.x / TAU) * TAU
	if camera_rot_target.x < 0.0:
		offset += TAU if is_less_than_half else -TAU
	
	camera_rot_target.y = 0.0 
	
	camera_rot_target.x = offset + difference.x * PI / 2.0

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
	
	if is_instance_valid(looked_at_object): look_at_object()
	
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
		#"jump", "falling":
			# This doesn't work
			#if has_set_jump_move_bob_down:
				#camera_rot_offset.y = lerpf(camera_rot_offset.y, deg_to_rad(15.0), delta * player.JUMP_POWER)
			#else:
				#camera_rot_offset.y = deg_to_rad(-10)
			#camera_rot_offset.x = lerp(camera_rot_offset.x, 0.0, delta)
			#has_set_jump_move_bob_down = true
			#return
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
	#has_set_jump_move_bob_down = false

func set_move_bob() -> void:
	if !can_do_rot_offset: return
	camera_rot_offset_sin = Vector2(sin(time / 2), sin(time))
	
	camera_rot_offset.x = deg_to_rad(move_bob_multiplier * MOVE_BOB * camera_rot_offset_sin.x)
	camera_rot_offset.y = deg_to_rad(move_bob_multiplier * MOVE_BOB * camera_rot_offset_sin.y)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and can_rotate == 0 and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_rot_target.x += -event.relative.x * SaveManager.settings.sensitivity
		camera_rot_target.y += -event.relative.y * SaveManager.settings.sensitivity
	elif event.is_action_pressed("change_mouse_mode"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
	# FIXME: ^ get rid of change_mouse_mode later when publishing the game.

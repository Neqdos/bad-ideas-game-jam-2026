extends ObjectInteractAction
class_name ObjectDoor

signal closed()
signal opened()

@export var hinge: HingeJoint3D
@export_enum("LEFT/RIGHT:0", "DOWN/UP:1") var move_direction: int = 0
@export var reversed_move: bool = false

@export var close_rotation: Vector3
@export var close_threshold: float = 2.0

@onready var door: RigidBody3D = get_parent()

const SMOOTHNESS: float = 10.0

var is_grabbed: bool = false
var just_grabbed: bool = false

var last_player: PlayerBody

var is_closed: bool = true

func _ready() -> void:
	_base_ready()
	interacted.connect(_on_interacted)
	action_text = "Grab"

func _on_interacted(player: PlayerBody) -> void:
	if !is_instance_valid(player.player_interaction_ray.grabbed_object):
		player.player_interaction_ray.grabbed_object = door
		is_grabbed = true
		last_player = player
	else:
		player.player_interaction_ray.grabbed_object = null
		is_grabbed = false
	check_for_grabbed()

func check_for_grabbed() -> void:
	if is_grabbed:
		hinge.set_flag(HingeJoint3D.FLAG_ENABLE_MOTOR, true)
		SignalManager.camera_lock.emit(true)
		just_grabbed = true
		door.freeze = false
		is_closed = false
		opened.emit()
	else:
		hinge.set_flag(HingeJoint3D.FLAG_ENABLE_MOTOR, false)
		hinge.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, 0.0)
		SignalManager.camera_lock.emit(false)
		door.linear_velocity = Vector3.ZERO
		door.angular_velocity = Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if !is_grabbed: return
	
	if event is InputEventMouseMotion:
		var moved_amount: float = event.relative.y if move_direction else event.relative.x
		if reversed_move: moved_amount *= -1
		
		hinge.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, moved_amount)
		
		await get_tree().process_frame
		
		door.linear_velocity = Vector3.ZERO
		door.angular_velocity = Vector3.ZERO

func close() -> void:
	interacted.emit(last_player)
	check_for_grabbed()
	door.rotation_degrees = close_rotation
	door.freeze = true
	is_closed = true
	closed.emit()

func _process(delta: float) -> void:
	if !is_grabbed: return
	
	hinge.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, lerpf(hinge.get("motor/target_velocity"), 0.0, delta * SMOOTHNESS))
	
	var vec_difference: Vector3 = door.rotation_degrees - close_rotation
	if absf(vec_difference.length()) < close_threshold:
		if just_grabbed: return
		close()
	elif just_grabbed: just_grabbed = false

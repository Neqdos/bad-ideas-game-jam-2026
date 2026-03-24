extends Node3D

@onready var door_left: MeshInstance3D = %DoorLeft
@onready var door_right: MeshInstance3D = %DoorRight

@onready var hour_arrow: MeshInstance3D = %HourArrow
@onready var minute_arrow: MeshInstance3D = %MinuteArrow

@onready var door_stick: MeshInstance3D = %DoorStick
@onready var cuckoo_cooldown: Timer = %CuckooCooldown

@onready var cuckoo_sound: AudioStreamPlayer3D = %CuckooSound

@onready var swingy_ball: Node3D = %SwingyBall

const OPEN_ROTATION: float = 120.0

const STICK_CLOSE_Z: float = 0.05
const STICK_OPEN_Z: float = -0.125

const BALLS_MAX_ROT: float = PI / 8.0

var previous_hour: int

var tween: Tween
var tween_ball: Tween

func _ready() -> void:
	var time: Dictionary = DesktopManager.get_time_dict()
	previous_hour = time["hour"]
	
	tween_ball = get_tree().create_tween().set_loops()
	tween_ball.tween_property(swingy_ball, "rotation:z", -BALLS_MAX_ROT, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween_ball.tween_property(swingy_ball, "rotation:z", BALLS_MAX_ROT, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)


func _process(delta: float) -> void:
	var time: Dictionary = DesktopManager.get_time_dict()
	
	minute_arrow.rotation.z = time["minute"] / 60.0 * TAU
	hour_arrow.rotation.z = time["hour"] / 12.0 * TAU
	
	if previous_hour != time["hour"] and !DesktopManager.is_using_clock:
		cuckoo()
	previous_hour = time["hour"]

func cuckoo() -> void:
	if cuckoo_cooldown.time_left: return
	cuckoo_cooldown.start()
	
	tween = get_tree().create_tween().set_parallel()
	tween.tween_property(door_left, "rotation:y", -deg_to_rad(OPEN_ROTATION), .5)
	tween.tween_property(door_right, "rotation:y", deg_to_rad(OPEN_ROTATION), .5)
	tween.tween_property(door_stick, "position:z", STICK_OPEN_Z, .5)
	
	for i: int in range(5):
		cuckoo_sound.play()
		await cuckoo_sound.finished
		await  get_tree().create_timer(.3).timeout
	
	tween = get_tree().create_tween().set_parallel()
	tween.tween_property(door_left, "rotation:y", 0.0, .5)
	tween.tween_property(door_right, "rotation:y", 0.0, .5)
	tween.tween_property(door_stick, "position:z", STICK_CLOSE_Z, .5)

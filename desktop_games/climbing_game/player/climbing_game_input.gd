extends DesktopGameInput
class_name ClimbingGameInput

signal jumped()
signal restart()

var input_x: float = 0.0
var input_y: float = 0.0

var jump_released: bool = false
var jump_pressed: bool = false
var just_jumped: bool = false

var grappling_hook_pressed: bool = false

var is_locked: int = 0

func _ready() -> void:
	DesktopManager.climbing_input_lock.connect(_on_input_lock)

func _on_input_lock(lock: bool) -> void:
	is_locked += int(lock) * 2 - 1

func _process(delta: float) -> void:
	if check_viewport(): return
	if is_locked: return
	
	input_x = Input.get_axis("left", "right")
	input_y = Input.get_axis("up", "down")
	
	if Input.is_action_just_pressed("jump"): jumped.emit()
	
	grappling_hook_pressed = Input.is_action_just_pressed("hook_shot")
	
	jump_pressed = Input.is_action_pressed("jump")
	just_jumped = Input.is_action_just_pressed("jump")
	jump_released = Input.is_action_just_released("jump")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reel"):
		restart.emit()

func reset() -> void:
	did_reset = true
	
	input_x = 0.0
	input_y = 0.0
	
	grappling_hook_pressed = false
	
	jump_released = false
	jump_pressed = false
	just_jumped = false

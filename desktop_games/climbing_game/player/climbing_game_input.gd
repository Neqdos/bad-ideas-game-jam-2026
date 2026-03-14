extends DesktopGameInput
class_name ClimbingGameInput

signal jumped()

var input_x: float = 0.0
var jump_released: bool = false

var is_locked: int = 0

func _ready() -> void:
	DesktopManager.climbing_input_lock.connect(_on_input_lock)

func _on_input_lock(lock: bool) -> void:
	is_locked += int(lock) * 2 - 1

func _process(delta: float) -> void:
	if check_viewport(): return
	if is_locked: return
	
	input_x = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump"): jumped.emit()
	
	jump_released = Input.is_action_just_released("jump")


func reset() -> void:
	did_reset = true
	
	input_x = 0.0
	jump_released = false

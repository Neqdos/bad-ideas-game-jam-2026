extends DesktopGameInput
class_name ClimbingGameInput

signal jumped()

var input_x: float = 0.0
var jump_released: bool = false

func _process(delta: float) -> void:
	if check_viewport(): return
	
	input_x = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump"): jumped.emit()
	
	jump_released = Input.is_action_just_released("jump")


func reset() -> void:
	did_reset = true
	
	input_x = 0.0
	jump_released = false

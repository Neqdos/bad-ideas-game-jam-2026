extends DesktopGameInput
class_name FishingGameInput

signal jumped()
signal reel()

var input_x: float


func _process(delta: float) -> void:
	if check_viewport(): return
	
	input_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"): jumped.emit()
	if Input.is_action_just_pressed("reel"): reel.emit()

func reset() -> void:
	did_reset = true
	
	input_x = 0.0

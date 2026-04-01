extends DesktopGameInput
class_name RPGInput

var input_vector: Vector2 = Vector2.ZERO

var is_locked: int = 0

func _ready() -> void:
	DesktopManager.rpg_input_lock.connect(_on_input_lock)

func _on_input_lock(lock: bool) -> void:
	is_locked += int(lock) * 2 - 1

func _process(delta: float) -> void:
	if check_viewport(): return
	if is_locked: return
	
	input_vector = Input.get_vector("left","right","up","down")

func reset() -> void:
	did_reset = true
	
	input_vector = Vector2.ZERO

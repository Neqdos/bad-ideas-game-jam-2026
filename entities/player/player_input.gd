extends Node
class_name PlayerInput

signal object_interact(released: bool)
signal object_hold()

signal interact(action_type: String, released: bool)

signal throw()

var input_vector: Vector2

var just_jumped: bool = false
var is_crouching: bool = false

var is_running: bool = false

var locks: int = 0


func _ready() -> void:
	SignalManager.player_input_lock.connect(_on_lock)

func _on_lock(locked: bool) -> void:
	locks += 1 if locked else -1
	input_vector = Vector2.ZERO
	just_jumped = false
	is_crouching = false
	
	process_mode = Node.PROCESS_MODE_INHERIT if locks == 0 else Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	input_vector = Input.get_vector("left", "right", "up", "down")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		just_jumped = true
	elif just_jumped:
		just_jumped = false
	
	if event.is_action_pressed("crouch"):
		is_crouching = true
	elif event.is_action_released("crouch"):
		is_crouching = false
	
	if event.is_action_pressed('run'):
		is_running = true
	elif event.is_action_released("run"):
		is_running = false
	
	
	if event.is_action_pressed("object_interact"): object_interact.emit(false)
	elif event.is_action_released("object_interact"): object_interact.emit(true)
	if event.is_action_pressed("object_hold"): object_hold.emit()
	
	if event.is_action_pressed("interact_primary"): interact.emit("interact_primary", false)
	elif event.is_action_released("interact_primary"): interact.emit("interact_primary", true)
	if event.is_action_pressed("interact_secondary"): interact.emit("interact_secondary", false)
	elif event.is_action_released("interact_secondary"): interact.emit("interact_secondary", true)
	
	if event.is_action_pressed("throw"): throw.emit()

extends FishingItem
class_name FishingItemAnchor

@export var level: int = 0

const FALL_LENGTH: float = 256.0
const FALL_SPEED: float = 64.0

var hook: FishingHook

var is_falling: bool = false
var distance_fallen: float = 0.0


func start() -> void:
	hook = get_parent()
	hook.can_catch = false
	is_falling = true

func end() -> void:
	hook.can_catch = true
	is_falling = false
	queue_free()

func reel() -> void:
	end()

func _physics_process(delta: float) -> void:
	if !is_falling: return
	
	if distance_fallen >= FALL_LENGTH * (level + 1):
		end()
		return
	
	hook.global_position.y += FALL_SPEED * delta
	distance_fallen += FALL_SPEED * delta

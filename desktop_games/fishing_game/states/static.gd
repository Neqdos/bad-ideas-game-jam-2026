extends State

@export var fish: Fish

const MIN_WAIT_TIME: float = 1.0
const MAX_WAIT_TIME: float = 5.0

var direction_side: int
var can_change_direction: bool = true

func enter() -> void:
	direction_side = -1 if randi() % 2 else 1

func physics_update(delta: float) -> void:
	if !fish.active: return
	
	if can_change_direction:
		can_change_direction = false
		fish.direction = Vector2.RIGHT * direction_side
		await get_tree().create_timer(randf_range(MIN_WAIT_TIME, MAX_WAIT_TIME)).timeout
		can_change_direction = true

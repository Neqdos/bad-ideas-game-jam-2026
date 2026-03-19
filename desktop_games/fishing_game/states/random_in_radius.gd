extends State

@export var fish: Fish

const MIN_WAIT_TIME: float = .25
const MAX_WAIT_TIME: float = 1.0

var radius: float
var point: Vector2

var is_waiting: bool = false

func enter() -> void:
	radius = fish.randomized_move_range

func physics_update(delta: float) -> void:
	if !fish.active: return
	if is_waiting: return
	
	var direction: Vector2 = point - fish.fish_area.position
	
	if direction.length() < fish.randomized_move_speed * delta:
		fish.fish_area.position += direction * delta
		is_waiting = true
		await get_tree().create_timer(randf_range(MIN_WAIT_TIME, MAX_WAIT_TIME)).timeout
		is_waiting = false
		calculate_point()
	else:
		fish.fish_area.position += direction.normalized() * fish.randomized_move_speed * delta
	
	fish.direction = direction

func calculate_point() -> void:
	point = (Vector2.RIGHT * radius * 8.0).rotated(randf() * TAU)

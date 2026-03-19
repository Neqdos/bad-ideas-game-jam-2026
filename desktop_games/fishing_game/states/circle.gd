extends State

@export var fish: Fish

@onready var circle_path: Path2D = %CirclePath
@onready var circle_path_follow: PathFollow2D = %Circle

var direction_side: int

func enter() -> void:
	circle_path_follow.progress_ratio = randf()
	circle_path.scale = Vector2(fish.randomized_move_range, fish.randomized_move_range)
	direction_side = -1 if randi() % 2 else 1
	fish.fish_area.global_position = circle_path_follow.global_position

func physics_update(delta: float) -> void:
	if !fish.active: return
	
	circle_path_follow.progress += fish.randomized_move_speed * delta * direction_side / fish.randomized_move_range
	
	fish.direction = circle_path_follow.global_position - fish.fish_area.global_position
	
	fish.fish_area.global_position = circle_path_follow.global_position

extends State

@export var fish: Fish

@onready var sideways_path: Path2D = %SidewaysPath
@onready var sideways_path_follow: PathFollow2D = %Sideways

var direction_side: int

func enter() -> void:
	sideways_path_follow.progress_ratio = randf()
	sideways_path.scale = Vector2(fish.randomized_move_range, fish.randomized_move_range)
	direction_side = -1 if randi() % 2 else 1

func physics_update(delta: float) -> void:
	if !fish.active: return
	
	sideways_path_follow.progress += fish.randomized_move_speed * delta * direction_side / fish.randomized_move_range
	
	fish.direction = sideways_path_follow.global_position - fish.fish_area.global_position
	
	fish.fish_area.global_position = sideways_path_follow.global_position

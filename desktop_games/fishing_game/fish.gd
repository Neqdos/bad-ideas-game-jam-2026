extends Node2D
class_name Fish

@onready var fish_sprite: Sprite2D = %FishSprite
@onready var fish_area: Area2D = %FishArea

# Paths:
@onready var sideways: PathFollow2D = %Sideways
@onready var circle: PathFollow2D = %Circle

const MOVE_RANGE_RANDOM_RANGE: float = .25
const MOVE_SPEED_RANDOM_RANGE: float = .2

var move_range_random: float
var move_speed_random: float

var tween: Tween

var fish_res: FishResource

var active: bool = false
var cought_fish_hook: FishingHook = null

var direction_side: int
var current_path: PathFollow2D

func _physics_process(delta: float) -> void:
	if is_instance_valid(cought_fish_hook):
		fish_area.global_position = fish_area.global_position.lerp(cought_fish_hook.global_position, delta * 16.0)
		return
	
	if !active: return
	
	if !is_instance_valid(current_path): return
	
	
	current_path.progress += move_speed_random * delta * direction_side
	
	var direction: Vector2 = current_path.global_position - fish_area.global_position
	var direction_normalized: Vector2 = direction.normalized()
	
	fish_sprite.flip_h = direction_normalized.x < 0
	fish_sprite.rotation = -direction_normalized.y * PI / 2.0 if fish_sprite.flip_h else direction_normalized.y * PI / 2.0
	
	fish_area.global_position = current_path.global_position


func restart() -> void:
	fish_area.monitorable = true
	visible = true
	cought_fish_hook = null
	
	fish_area.global_position = global_position
	
	fish_sprite.texture = fish_res.sprite
	
	direction_side = -1 if randi() % 2 else 1
	
	move_range_random = randf_range(fish_res.move_range - MOVE_RANGE_RANDOM_RANGE, fish_res.move_range + MOVE_RANGE_RANDOM_RANGE)
	move_speed_random = randf_range(fish_res.move_speed - MOVE_RANGE_RANDOM_RANGE, fish_res.move_speed + MOVE_RANGE_RANDOM_RANGE)
	
	current_path = _get_correct_path_follow()
	if is_instance_valid(current_path):
		current_path.scale = Vector2(move_range_random, move_range_random)
	
	active = true

func _get_correct_path_follow() -> PathFollow2D:
	match fish_res.move_pattern:
		FishResource.MOVE.Static:
			return null
		FishResource.MOVE.Sideways:
			return sideways
		FishResource.MOVE.Circle:
			return circle
		_:
			return null

func catch(fish_hook: FishingHook) -> void:
	active = false
	cought_fish_hook = fish_hook
	
	fish_area.set_deferred("monitorable", false)

func sell() -> void:
	visible = false
	DesktopManager.fishing_money += fish_res.default_money_value

@tool
extends Node2D
class_name FishSpawner

@export_enum("Rect:0", "Circle:1") var spawn_type: int = 1

## Used when spawn_type is set to Rect
@export var rect: Vector2i = Vector2(16, 16):
	set(val):
		rect = val
		if spawn_type == 1: return
		if rect.x < rect.y:
			radius = rect.x
		else:
			radius = rect.y
## Used when spawn_type is set to Circle
@export var radius: int = 16:
	set(val):
		radius = val
		if spawn_type == 0: return
		rect = Vector2(radius, radius)

@export var line: Line2D

@export var spawnable_fish: Dictionary[FishResource, float]
@export var default_fish_count: int = 1

const FISH_SCENE = preload("uid://b4awr14ncr34m")

const INITIAL_SELL_TIME: float = .3
const SELL_TIME_CHANGE: float = .85
var sell_time: float

var fish_array: Array[Fish]

func _ready() -> void:
	if Engine.is_editor_hint():
		if is_instance_valid(line): return
		line = Line2D.new()
		line.name = "SpawnAreaLine"
		line.width = 1.0
		line.closed = true
		add_child(line)
		line.owner = get_tree().edited_scene_root
		return
	
	DesktopManager.fishing_game_started.connect(_on_fishing_game_started)
	DesktopManager.fishing_game_ended.connect(_on_fishing_game_ended)
	
	add_fish(default_fish_count)
	
	if is_instance_valid(line): line.queue_free()

func _process(delta: float) -> void:
	if !Engine.is_editor_hint(): return
	
	if !is_instance_valid(line): return
	
	const CIRCLE_POINT_AMOUNT: int = 18
	
	line.clear_points()
	
	match spawn_type:
		0:
			line.add_point(Vector2(-rect.x, rect.y))
			line.add_point(Vector2(rect.x, rect.y))
			line.add_point(Vector2(rect.x, -rect.y))
			line.add_point(Vector2(-rect.x, -rect.y))
		1:
			for i: int in range(CIRCLE_POINT_AMOUNT):
				line.add_point((Vector2.RIGHT * radius).rotated((TAU / CIRCLE_POINT_AMOUNT) * i))

func _on_fishing_game_started() -> void:
	if fish_array.size() < default_fish_count * DesktopManager.fishing_stats["fish_mult"]:
		add_fish(default_fish_count * int(DesktopManager.fishing_stats["fish_mult"]) - fish_array.size())
		await get_tree().process_frame
	
	for fish: Fish in fish_array:
		if fish.get_parent() != self: fish.reparent(self)
		randomize_fish_resource(fish)
		set_fish_position(fish)
		fish.restart()

func _on_fishing_game_ended() -> void:
	sell_time = INITIAL_SELL_TIME
	
	for fish: Fish in fish_array:
		if !is_instance_valid(fish.cought_fish_hook): continue
		
		fish.sell()
		await  get_tree().create_timer(sell_time).timeout
		sell_time *= SELL_TIME_CHANGE
	
	DesktopManager.fishing_all_sold.emit()

func add_fish(amount: int) -> void:
	for i: int in range(amount):
		var new_fish: Fish = FISH_SCENE.instantiate()
		fish_array.append(new_fish)
		add_child(new_fish)

func randomize_fish_resource(fish: Fish) -> void:
	var sum_of_wages: float = 0.0
	
	for v: float in spawnable_fish.values():
		sum_of_wages += v
	
	var random: float = randf_range(0.0, sum_of_wages)
	
	for fish_res: FishResource in spawnable_fish:
		if random <= spawnable_fish[fish_res]:
			fish.fish_res = fish_res
			return
		random -= spawnable_fish[fish_res]
	
	push_error("That shouldn't happen, ", spawnable_fish)

func set_fish_position(fish: Fish) -> void:
	match spawn_type:
		0:
			var random_x: float = randf_range(-rect.x, rect.x)
			var random_y: float = randf_range(-rect.y, rect.y)
			fish.global_position = global_position + Vector2(random_x, random_y)
		1:
			var random_angle: float = randf_range(0.0, TAU)
			var random_distance: float = randf_range(0.0, radius)
			fish.global_position = global_position + (Vector2.RIGHT * random_distance).rotated(random_angle)

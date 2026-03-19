extends Node2D

@onready var fishing_hook: FishingHook = %FishingHook
@onready var fishing_game_input: FishingGameInput = %FishingGameInput
@onready var fishing_line: Line2D = %FishingLine

@onready var hook_camera: PhantomCamera2D = %HookCamera
@onready var rest_camera: PhantomCamera2D = %RestCamera

const REELING_SPEED: float = 128.0
const STARTING_HOOK_POSITION: Vector2 = Vector2.ZERO

var tween: Tween

var can_start_game: bool = true

func _ready() -> void:
	fishing_game_input.jumped.connect(_on_try_start)
	
	DesktopManager.fishing_game_started.connect(_on_fishing_game_started)
	DesktopManager.fishing_game_reeling.connect(_on_fishing_game_reeling)
	DesktopManager.fishing_game_ended.connect(_on_fishing_game_ended)
	DesktopManager.fishing_all_sold.connect(_on_fishing_all_sold)

func _on_try_start() -> void:
	if !can_start_game: return
	
	DesktopManager.fishing_game_started.emit()

func _on_fishing_game_started() -> void:
	DesktopManager.fishing_game_is_going = true
	fishing_hook.can_move = true
	can_start_game = false
	
	rest_camera.priority = 0
	hook_camera.priority = 1

func _on_fishing_game_reeling() -> void:
	DesktopManager.fishing_game_is_going = false
	fishing_hook.can_move = false
	
	tween = get_tree().create_tween()
	tween.tween_property(fishing_hook, "global_position", STARTING_HOOK_POSITION, fishing_hook.global_position.distance_to(STARTING_HOOK_POSITION) / REELING_SPEED)
	
	await tween.finished
	
	DesktopManager.fishing_game_ended.emit()

func _on_fishing_game_ended() -> void:
	rest_camera.priority = 1
	hook_camera.priority = 0

func _on_fishing_all_sold() -> void:
	can_start_game = true

func _physics_process(delta: float) -> void:
	fishing_line.set_point_position(1, fishing_hook.global_position)
	
	if fishing_line.points[0].distance_to(fishing_hook.global_position) >= DesktopManager.fishing_stats.line_length:
		DesktopManager.fishing_game_reeling.emit()

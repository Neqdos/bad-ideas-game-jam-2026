extends CharacterBody2D
class_name FishingHook

@export var input: FishingGameInput

@onready var fishing_area: Area2D = %FishingArea
@onready var fishing_area_collision_shape: CollisionShape2D = %FishingAreaCollisionShape

const GRAVITY: float = 64.0
const MAX_GRAVITY: float = 24.0

var can_move: bool = false

var item = null

var jump_on_cooldown: bool = false

func _ready() -> void:
	input.jumped.connect(_on_jumped)
	input.reel.connect(_on_reel)
	
	fishing_area.area_entered.connect(_on_area_entered)
	
	DesktopManager.fishing_game_started.connect(_on_fishing_game_started)

func _physics_process(delta: float) -> void:
	if !can_move: return
	
	if velocity.y < MAX_GRAVITY:
		velocity.y += GRAVITY * delta
	
	velocity.x = input.input_x * DesktopManager.fishing_stats["moving_speed"]
	
	move_and_slide()

func _on_jumped() -> void:
	if !DesktopManager.fishing_game_is_going: return
	
	if is_instance_valid(item):
		pass
	elif !jump_on_cooldown:
		jump_on_cooldown = true
		velocity.y = -DesktopManager.fishing_stats["jump_strength"]
		await get_tree().create_timer(DesktopManager.fishing_stats["jump_cooldown"]).timeout
		jump_on_cooldown = false

func _on_reel() -> void:
	if !DesktopManager.fishing_game_is_going: return
	DesktopManager.fishing_game_reeling.emit()

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Fish:
		var fish: Fish = area.get_parent()
		fish.catch(self)

func _on_fishing_game_started() -> void:
	var shape: CircleShape2D = fishing_area_collision_shape.shape
	shape.radius = DesktopManager.fishing_stats["area_size"]

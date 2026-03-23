extends Area2D
class_name HookShot

@export var player: ClimbingPlayer
@export var player_state_machine: StateMachine

@onready var wrong_surface_area: Area2D = %WrongSurfaceArea
@onready var hook_sprite: Sprite2D = %HookSprite

const SPEED: float = 196.0

var active: bool = false

var direction: Vector2

var distance_travelled: float = 0.0

var tween: Tween

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	wrong_surface_area.body_entered.connect(_on_wrong_surface_area_body_entered)
	

func _on_body_entered(body: Node2D) -> void:
	if !active: return
	active = false
	
	tween = get_tree().create_tween().set_parallel()
	tween.tween_property(player, "global_position", global_position, global_position.distance_to(player.global_position) / SPEED)
	tween.tween_property(self, "position", Vector2.ZERO, global_position.distance_to(player.global_position) / SPEED)
	
	await tween.finished
	
	_stop()

func _on_wrong_surface_area_body_entered(body: Node2D) -> void:
	if !active: return
	_stop()

func shoot(dir: Vector2) -> void:
	direction = dir
	distance_travelled = 0.0
	global_position = player.global_position
	
	if dir.x:
		hook_sprite.rotation = -PI * clampf(dir.x, -1.0, 0.0)
	else:
		hook_sprite.rotation = -PI / 2.0 * dir.y
	
	visible = true
	active = true

func _physics_process(delta: float) -> void:
	if !active: return
	
	global_position += direction * delta * SPEED
	distance_travelled += delta * SPEED
	
	if distance_travelled > DesktopManager.max_hook_travel_distance:
		_stop()

func _stop() -> void:
	visible = false
	active = false
	player_state_machine.change_state("idle")

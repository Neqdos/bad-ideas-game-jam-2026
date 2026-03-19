extends Node2D
class_name Fish

@onready var fish_sprite: Sprite2D = %FishSprite
@onready var fish_area: Area2D = %FishArea
@onready var fish_collision_shape: CollisionShape2D = %FishCollisionShape

@onready var special_particles: GPUParticles2D = %SpecialParticles

@onready var visible_notifier: VisibleOnScreenNotifier2D = %VisibleNotifier

@onready var state_machine: StateMachine = %StateMachine

const MOVE_RANGE_RANDOM_RANGE: float = .25
const MOVE_SPEED_RANDOM_RANGE: float = .2

const SPECIAL_CHANCE: float = .05
const SPECIAL_MULT: float = 3.0
var is_special: bool = false

const SIZE_TO_RADIUS: Dictionary[FishResource.SIZE, float] = {
	FishResource.SIZE.Small : 6.0,
	FishResource.SIZE.Medium: 10.0,
	FishResource.SIZE.Big : 18.0,
}

var randomized_move_range: float
var randomized_move_speed: float

var tween: Tween

var fish_res: FishResource

var active: bool = false
var cought_fish_hook: FishingHook = null

var direction: Vector2 = Vector2.ZERO

var time: float = 0.0


func _ready() -> void:
	visible_notifier.screen_entered.connect(_on_visible_notifier_screen_entered)
	visible_notifier.screen_exited.connect(_on_visible_notifier_screen_exited)

func _physics_process(delta: float) -> void:
	time += delta
	
	if is_instance_valid(cought_fish_hook):
		fish_area.global_position = fish_area.global_position.lerp(cought_fish_hook.global_position, delta * 16.0)
		return
	
	var direction_normalized: Vector2 = direction.normalized()
	
	fish_sprite.flip_h = direction_normalized.x < 0
	fish_sprite.rotation = -direction_normalized.y * PI / 2.0 if fish_sprite.flip_h else direction_normalized.y * PI / 2.0
	fish_sprite.rotation += sin(time * 10.0) * deg_to_rad(15.0)

func _on_visible_notifier_screen_exited() -> void:
	if is_instance_valid(cought_fish_hook): return
	special_particles.visible = false
	special_particles.restart()
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_visible_notifier_screen_entered() -> void:
	special_particles.visible = is_special
	special_particles.restart()
	process_mode = Node.PROCESS_MODE_INHERIT

func restart() -> void:
	fish_area.monitorable = true
	visible = true
	cought_fish_hook = null
	
	var shape: CircleShape2D = fish_collision_shape.shape
	shape.set_deferred("radius", SIZE_TO_RADIUS[fish_res.fish_size])
	
	fish_area.global_position = global_position
	
	fish_sprite.texture = fish_res.sprite
	
	randomized_move_range = randf_range(fish_res.move_range * (1.0 - MOVE_RANGE_RANDOM_RANGE), fish_res.move_range * (1.0 + MOVE_RANGE_RANDOM_RANGE))
	randomized_move_speed = randf_range(fish_res.move_speed * (1.0 - MOVE_SPEED_RANDOM_RANGE), fish_res.move_speed * (1.0 + MOVE_SPEED_RANDOM_RANGE))
	
	update_state()
	
	is_special = randf() < SPECIAL_CHANCE
	
	await get_tree().create_timer(randf_range(.1, .5)).timeout
	
	special_particles.visible = is_special
	
	active = true

func update_state() -> void:
	match fish_res.move_pattern:
		FishResource.MOVE.Static:
			state_machine.change_state("static")
		FishResource.MOVE.Sideways:
			state_machine.change_state("sideways")
		FishResource.MOVE.Circle:
			state_machine.change_state("circle")
		FishResource.MOVE.RandomInRadius:
			state_machine.change_state("randominradius")
		_:
			state_machine.change_state("static")
			push_error("No valid state.")

func catch(fish_hook: FishingHook) -> void:
	active = false
	cought_fish_hook = fish_hook
	
	fish_area.set_deferred("monitorable", false)

func sell() -> void:
	visible = false
	DesktopManager.fishing_money += fish_res.default_money_value if !is_special else fish_res.default_money_value * SPECIAL_MULT

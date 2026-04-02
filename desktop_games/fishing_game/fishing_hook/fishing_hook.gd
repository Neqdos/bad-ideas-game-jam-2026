extends CharacterBody2D
class_name FishingHook

@export var input: FishingGameInput

@onready var fishing_area: Area2D = %FishingArea
@onready var fishing_area_collision_shape: CollisionShape2D = %FishingAreaCollisionShape

@onready var area_line: Line2D = %AreaLine

@onready var sell_sfx: DesktopAudioPlayer = %SellSFX
@onready var caught_sfx: DesktopAudioPlayer = %CaughtSFX
@onready var hook_sprite: Sprite2D = %HookSprite

const GRAVITY: float = 64.0

const INITIAL_SELL_TIME: float = .3
const SELL_TIME_CHANGE: float = .85
var sell_time: float

var cought_fish_array: Array[Fish]

var can_move: bool = false
var can_catch: bool = true
var has_victor_bait: bool = false

var jump_on_cooldown: bool = false

var capacity: int

func _ready() -> void:
	DesktopManager.fishing_hook = self
	
	input.jumped.connect(_on_jumped)
	input.reel.connect(_on_reel)
	
	DesktopManager.fishing_game_started.connect(_on_fishing_game_started)
	DesktopManager.fishing_game_ended.connect(_on_fishing_game_ended)
	
	fishing_area.area_entered.connect(_on_fishing_area_entered)
	
	_draw_area_line()

func _physics_process(delta: float) -> void:
	hook_sprite.frame = DesktopManager.fishing_stats.hook_size
	
	if !can_move: return
	
	if DesktopManager.reversed_gravity:
		velocity.y -= GRAVITY * delta * float(velocity.y > -DesktopManager.fishing_stats.falling_speed)
	else:
		velocity.y += GRAVITY * delta * float(velocity.y < DesktopManager.fishing_stats.falling_speed)
	
	velocity.x = input.input_x * DesktopManager.fishing_stats.moving_speed * DesktopManager.reversed_gravity_strength
	
	#_check_for_fish()
	
	move_and_slide()

func _on_jumped() -> void:
	if !DesktopManager.fishing_game_is_going: return
	
	if !jump_on_cooldown:
		jump_on_cooldown = true
		velocity.y = -DesktopManager.fishing_stats.jump_strength * DesktopManager.reversed_gravity_strength
		await get_tree().create_timer(DesktopManager.fishing_stats.jump_cooldown).timeout
		jump_on_cooldown = false

func _on_reel() -> void:
	if !DesktopManager.fishing_game_is_going: return
	DesktopManager.fishing_game_reeling.emit()

func _check_for_fish() -> void:
	if !DesktopManager.fishing_game_is_going: return
	if capacity <= 0: return
	if !can_catch: return
	if !fishing_area.has_overlapping_areas(): return
	
	for area: Area2D in fishing_area.get_overlapping_areas():
		if area.get_parent() is Fish:
			var fish: Fish = area.get_parent()
			
			if fish.fish_res.fish_size > DesktopManager.fishing_stats.hook_size: return
			
			if !DesktopManager.fishing_compendium.has(fish.fish_res):
				DesktopManager.fishing_compendium.append(fish.fish_res)
			fish.catch(self)
			caught_sfx.play()
			cought_fish_array.append(fish)
			capacity -= 1
			if capacity == 0: DesktopManager.fishing_game_reeling.emit()
		elif has_victor_bait:
			var victor: VictorSprite = GlobalMethods.find_first_child_of_type(area, VictorSprite)
			if !is_instance_valid(victor): return
			
			victor.death()
			has_victor_bait = false
			await victor.died
			area.queue_free.call_deferred()
			DesktopManager.victors_defeated += 1

func _on_fishing_area_entered(area: Area2D) -> void:
	if !DesktopManager.fishing_game_is_going: return
	if capacity <= 0: return
	if !can_catch: return
	
	if area.get_parent() is Fish:
		var fish: Fish = area.get_parent()
		
		if fish.fish_res.fish_size > DesktopManager.fishing_stats.hook_size: return
		
		if !DesktopManager.fishing_compendium.has(fish.fish_res):
			DesktopManager.fishing_compendium.append(fish.fish_res)
		fish.catch(self)
		caught_sfx.play()
		cought_fish_array.append(fish)
		capacity -= 1
		if capacity == 0: DesktopManager.fishing_game_reeling.emit()
	elif has_victor_bait:
		var victor: VictorSprite = GlobalMethods.find_first_child_of_type(area, VictorSprite)
		if !is_instance_valid(victor): return
		
		victor.death()
		has_victor_bait = false
		await victor.died
		area.queue_free.call_deferred()
		DesktopManager.victors_defeated += 1

func _on_fishing_game_started() -> void:
	capacity = DesktopManager.fishing_stats.max_capacity
	
	var shape: CircleShape2D = fishing_area_collision_shape.shape
	shape.radius = DesktopManager.fishing_stats.area_size
	
	_draw_area_line()


func _on_fishing_game_ended() -> void:
	sell_time = INITIAL_SELL_TIME
	
	for fish: Fish in cought_fish_array:
		fish.sell()
		sell_sfx.play()
		await  get_tree().create_timer(sell_time).timeout
		sell_time *= SELL_TIME_CHANGE
	
	cought_fish_array.clear()
	DesktopManager.fishing_all_sold.emit()

func _draw_area_line() -> void:
	const POINTS_COUNT: int = 9
	
	var radius: float = DesktopManager.fishing_stats.area_size
	area_line.clear_points()
	
	for i: int in range(POINTS_COUNT):
		var pos: Vector2 = (Vector2.RIGHT * radius).rotated(TAU / POINTS_COUNT * i)
		area_line.add_point(pos)

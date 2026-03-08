extends Node
class_name HealthComponent

# This might need some work and changes.

signal died()
signal health_changed(amount: float)

@export var main_node: Node3D

@export var max_health: float
@export var passive_regen: float = 1.0

@onready var health: float = max_health:
	set(val):
		health = clampf(val, 0.0, max_health)
		if is_zero_approx(health): died.emit()

@export var delete_on_death: bool = true

@export var material_type: AttackInteractAction.MATERIAL_TYPES

var regen_timer: Timer = Timer.new()

func _ready() -> void:
	regen_timer.timeout.connect(_on_regen)
	add_child(regen_timer)
	regen_timer.start()
	
	if delete_on_death:
		died.connect(_on_died)

func _on_regen() -> void:
	change_health(passive_regen)

func change_health(amount: float, from_point: Vector3 = Vector3.ZERO) -> void:
	health += amount
	health_changed.emit(amount)

func _on_died() -> void:
	var aabb: AABB = GlobalMethods.get_merged_aabb_from_meshes(GlobalMethods.get_correct_meshes_from_a_node(main_node))
	GlobalMethods.create_sleep_area_of_influence(main_node.global_position, aabb.size, get_tree().current_scene)
	
	main_node.queue_free.call_deferred()

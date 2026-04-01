extends HandInteractAction
class_name AttackInteractAction

@export var attack: WeaponAttack
## The animation to play when the object is being interacted should be named named "[b]attack[/b]".
@export var animation_player: AnimationPlayer
## Only needed if there is no animation player and you want to play the default animation when the object is being interacted.
@export var model: Node3D

const MATERIAL_TO_PARTICLE = {
	1: preload("uid://dpcmwmydcr64b"),
}

enum MATERIAL_TYPES {
	None = 0,
	Wood = 1,
}

var tween: Tween

func _ready() -> void:
	_base_ready()
	interacted.connect(_on_interacted)

func _on_interacted(player: PlayerBody) -> void:
	if is_instance_valid(animation_player): animation_player.play("attack")
	elif is_instance_valid(model): play_default_animation()
	
	if !is_instance_valid(player.player_interaction_ray.interactable): return
	
	apply_damage(player)
	apply_knockback(player)

func apply_damage(player: PlayerBody) -> void:
	var health_component: HealthComponent = GlobalMethods.find_first_child_of_type(player.player_interaction_ray.interactable, HealthComponent)
	if !is_instance_valid(health_component): return
	
	health_component.change_health(-attack.damage, player.player_interaction_ray.get_collision_point())
	
	if health_component.material_type == MATERIAL_TYPES.None: return
	
	var new_particle_scene: PackedScene = MATERIAL_TO_PARTICLE[health_component.material_type]
	var new_particle: GPUParticles3D = new_particle_scene.instantiate()
	
	new_particle.emitting = true
	new_particle.finished.connect(new_particle.queue_free)
	get_tree().current_scene.add_child(new_particle)
	new_particle.global_position = player.player_interaction_ray.get_collision_point()

func apply_knockback(player: PlayerBody) -> void:
	if !(player.player_interaction_ray.interactable is RigidBody3D): return
	player.player_interaction_ray.force_raycast_update()
	
	var ray_interactable: RigidBody3D = player.player_interaction_ray.interactable
	var pos_offset: Vector3 = player.player_interaction_ray.get_collision_point() - ray_interactable.global_position#.rotated(Vector3(0, 1, 0), PI)
	
	ray_interactable.apply_impulse(GlobalMethods.get_direction_from_node3d(player) * attack.knockback, pos_offset)


func play_default_animation() -> void:
	if tween: tween.stop()
	
	model.rotation.x = -PI / 3
	tween = get_tree().create_tween()
	tween.tween_property(model, "rotation:x", 0.0, .24).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

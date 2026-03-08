extends AnimatableBody3D
class_name MovingPlatform

## The first point should have platform's default transform.
@export var point_a: Marker3D
@export var point_b: Marker3D

@export var can_move_while_moving: bool = false

@export var tween_time: float
@export var tween_trans: Tween.TransitionType = Tween.TRANS_LINEAR
@export var tween_ease: Tween.EaseType = Tween.EASE_IN_OUT

var current_target_a: bool = false

var tween: Tween

func move() -> void:
	if !can_move_while_moving and tween: return
	if tween: tween.kill()
	
	var distance_between_points: float = point_a.global_position.distance_to(point_b.global_position)
	var distance_to_target_point: float = global_position.distance_to(point_a.global_position if current_target_a else point_b.global_position)
	var fixed_tween_time: float = (distance_to_target_point / distance_between_points) * tween_time
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_transform", point_a.global_transform if current_target_a else point_b.global_transform, fixed_tween_time).set_trans(tween_trans).set_ease(tween_ease)
	
	current_target_a = !current_target_a
	
	await tween.finished
	
	if !tween.is_running(): tween = null

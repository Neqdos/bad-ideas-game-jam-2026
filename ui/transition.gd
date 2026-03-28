extends ColorRect
class_name Transition

signal transition_finished()

var tween: Tween

var shader_material: ShaderMaterial

func _ready() -> void:
	shader_material = material

func do_transition(visibility: bool, time: float) -> void:
	shader_material.set_shader_parameter("progress", float(visibility))
	visible = true
	
	tween = get_tree().create_tween()
	tween.tween_property(shader_material, "shader_parameter/progress", float(!visibility), time)
	
	await tween.finished
	
	transition_finished.emit()
	
	visible = visibility

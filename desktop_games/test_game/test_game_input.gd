extends Node
class_name TestGameInput

@export var app_node: Node2D

var input_dir_x: float = 0.0

var just_jumped: bool = false

var did_reset: bool = false

func _physics_process(_delta: float) -> void:
	var viewport: SubViewport = app_node.get_parent()
	if viewport.gui_disable_input:
		if !did_reset: reset()
		return
	did_reset = false
	
	input_dir_x = Input.get_axis("left", "right")
	just_jumped = Input.is_action_just_pressed("up")
	
func reset() -> void:
	did_reset = true
	
	input_dir_x = 0.0
	just_jumped = false

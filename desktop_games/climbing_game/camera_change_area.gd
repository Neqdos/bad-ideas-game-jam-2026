extends Area2D
class_name CameraChangeArea

@export var camera_enter: PhantomCamera2D
@export var camera_exit: PhantomCamera2D
@export_enum("left", "right", "up", "down") var enter_direction: String = "left"
@export var host: PhantomCameraHost


func _ready() -> void:
	#body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

#func _on_body_entered(body: Node2D) -> void:
	#print("body entered in ", name)
	#if !active: return
	#
	#if body is ClimbingPlayer:
		#await get_tree().process_frame
		#
		#var pcam: PhantomCamera2D = host.get_active_pcam()
		#camera.priority = 1
		#pcam.priority = 0

func _on_body_exited(body: Node2D) -> void:
	if body is ClimbingPlayer:
		var entered: bool = false
		
		match enter_direction:
			"left":
				if body.global_position.x < global_position.x: entered = true
			"right":
				if body.global_position.x > global_position.x: entered = true
			"up":
				if body.global_position.y < global_position.y: entered = true
			"down":
				if body.global_position.y > global_position.y: entered = true
		
		var pcam: PhantomCamera2D = host.get_active_pcam()
		if entered:
			if pcam == camera_enter: return
			camera_enter.priority = 1
		else:
			if pcam == camera_exit: return
			camera_exit.priority = 1
		pcam.priority = 0

extends Area2D
class_name SpawnArea

@export var camera: PhantomCamera2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is ClimbingPlayer:
		DesktopManager.climbing_spawn_area = self

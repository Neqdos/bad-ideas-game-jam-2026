extends Area3D
class_name TeleportArea

@export var marker: Marker3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	body.global_position = marker.global_position

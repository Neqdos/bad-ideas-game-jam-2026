extends Area2D

@export var door_block_switch: DoorBlockSwitch

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is ClimbingPlayer:
		door_block_switch.switch()

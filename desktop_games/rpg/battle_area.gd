extends Area2D
class_name BattleArea

@export var min_time: float = 5.0
@export var max_time: float = 20.0

@export var battles: Array[int]


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is RPGPlayer:
		# Start battle
		pass

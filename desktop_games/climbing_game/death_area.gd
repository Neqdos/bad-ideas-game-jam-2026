extends Area2D
class_name DeathArea

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is ClimbingPlayer:
		DesktopManager.climbing_player_death.emit()

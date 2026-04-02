extends Area2D
class_name BattleArea

@export var battle: BattleResource


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is RPGPlayer:
		DesktopManager.rpg_start_battle.emit(battle)
		queue_free.call_deferred()

@abstract
extends Node2D
class_name FishingItem


func _ready() -> void:
	DesktopManager.fishing_game_started.connect(start)
	DesktopManager.fishing_game_ended.connect(end)

@abstract
func start() -> void

@abstract
func end() -> void

extends Control

func _ready() -> void:
	DesktopManager.climbing_items_changed.connect(_on_climbing_items_changed)

func _on_climbing_items_changed() -> void:
	pass

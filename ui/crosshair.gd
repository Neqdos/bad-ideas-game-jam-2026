extends ColorRect
class_name Crosshair

func _ready() -> void:
	SignalManager.change_player_ui_visibility.connect(_on_change_hotbar_visibility)

func _on_change_hotbar_visibility(visibility: bool) -> void:
	visible = visibility

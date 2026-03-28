extends Control

@onready var wings: NinePatchRect = %Wings

func _ready() -> void:
	DesktopManager.climbing_items_changed.connect(_on_climbing_items_changed)

func _on_climbing_items_changed() -> void:
	wings.visible = DesktopManager.has_wings

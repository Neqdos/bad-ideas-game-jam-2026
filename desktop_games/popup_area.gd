extends Area2D
class_name PopupArea

@export var popup_res: PopupResource

var used: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if used: return
	DesktopManager.show_popup(popup_res)
	used = true

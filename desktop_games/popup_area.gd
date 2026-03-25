extends Area2D
class_name PopupArea

@export var popup_res: PopupResource

var used: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if used: return
	used = true
	
	await get_tree().create_timer(randf_range(2.0, 10.0)).timeout
	
	DesktopManager.show_popup(popup_res)

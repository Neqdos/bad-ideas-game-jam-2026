extends Area2D
class_name FileObject

@export var file_res: FileResource

@onready var file_sprite: Sprite2D = %FileSprite

var used: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	file_sprite.texture = file_res.icon

func _on_body_entered(body: Node2D) -> void:
	if used: return
	DesktopManager.show_popup(DesktopManager.DISC_EXTRACTING_POPUP, {
		"file_res" : file_res,
		"type" : 1})
	used = true
	visible = false

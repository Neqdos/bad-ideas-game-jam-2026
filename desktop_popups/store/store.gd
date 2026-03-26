extends Control

@onready var buy_button: Button = %BuyButton

var hammer_scene_path: String = "uid://drq818rlsgnl0"

var used: bool = false

func _ready() -> void:
	buy_button.pressed.connect(_on_buy_button_pressed)

func _on_buy_button_pressed() -> void:
	if used: return
	used = true
	buy_button.disabled = true
	DesktopManager.spawn_hammer.emit()

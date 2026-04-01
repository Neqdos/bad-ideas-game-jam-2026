extends Control

@onready var buy_button: Button = %BuyButton

var hammer_scene_path: String = "uid://drq818rlsgnl0"

var used: bool = false

func _ready() -> void:
	buy_button.pressed.connect(_on_buy_button_pressed)
	
	if DesktopManager.used_store: buy_button.disabled = true
	
	var popup_window: PopupWindow = GlobalMethods.find_first_parent_of_type(self, PopupWindow)
	DesktopManager.unlock_popup_site(popup_window.popup_res)

func _on_buy_button_pressed() -> void:
	if used: return
	used = true
	buy_button.disabled = true
	DesktopManager.used_store = true
	DesktopManager.spawn_hammer.emit()

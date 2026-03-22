extends Control

@onready var okay_button: Button = %OkayButton

func _ready() -> void:
	okay_button.pressed.connect(_on_okay_pressed)

func _on_okay_pressed() -> void:
	var popup_window: PopupWindow = GlobalMethods.find_first_parent_of_type(self, PopupWindow)
	if is_instance_valid(popup_window): popup_window.close()
	DesktopManager.power_off.emit()

extends Control

@onready var yes_button: Button = %YesButton
@onready var no_button: Button = %NoButton

func _ready() -> void:
	yes_button.pressed.connect(func(): get_tree().quit())
	no_button.pressed.connect(_on_no_pressed)

func _on_no_pressed() -> void:
	var popup_window: PopupWindow = GlobalMethods.find_first_parent_of_type(self, PopupWindow)
	if is_instance_valid(popup_window): popup_window.close()

extends Control

@onready var buy_button: Button = %BuyButton
const BOOKS = preload("uid://mcyflw4hqvs1")


func _ready() -> void:
	buy_button.pressed.connect(_on_buy_button_pressed)
	
	if DesktopManager.used_online_course: buy_button.disabled = true
	
	var popup_window: PopupWindow = GlobalMethods.find_first_parent_of_type(self, PopupWindow)
	DesktopManager.unlock_popup_site(popup_window.popup_res)

func _on_buy_button_pressed() -> void:
	if DesktopManager.fishing_money >= 300.0:
		DesktopManager.fishing_money -= 300.0
		DesktopManager.used_online_course = true
		buy_button.disabled = true
		
		DesktopManager.show_popup(DesktopManager.DISC_EXTRACTING_POPUP, {
			"file_res" : BOOKS,
			"type" : 1})

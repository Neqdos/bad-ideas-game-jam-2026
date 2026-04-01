extends Control

@onready var generate_button: Button = %GenerateButton


const AI_IMAGE = preload("uid://bmmblhkbjdhbu")

func _ready() -> void:
	if DesktopManager.used_ai: generate_button.disabled = true
	
	generate_button.pressed.connect(_on_generate)
	
	var popup_window: PopupWindow = GlobalMethods.find_first_parent_of_type(self, PopupWindow)
	DesktopManager.unlock_popup_site(popup_window.popup_res)

func _on_generate() -> void:
	if DesktopManager.used_ai: return
	
	DesktopManager.used_ai = true
	generate_button.disabled = true
	
	DesktopManager.show_popup(DesktopManager.DISC_EXTRACTING_POPUP,
	{"file_res" : AI_IMAGE,
	"type" : 1})

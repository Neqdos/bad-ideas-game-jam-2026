extends Control

@onready var download_button: Button = %DownloadButton
const HACKED_INFO: TextFileResource = preload("uid://dux2bjc2vihto")


func _ready() -> void:
	download_button.pressed.connect(_on_download_pressed)
	
	var info: String = "First name: yes
Last name: also yes
Adress: Earth (probably)
IP Adress: 192.168.0.1 lol
Safe code: %s
Favorite animal: idk this one too hard
Has a virus on their PC: obviously yes" % DesktopManager.safe_code
	
	HACKED_INFO.set("data", info)
	
	var popup_window: PopupWindow = GlobalMethods.find_first_parent_of_type(self, PopupWindow)
	
	DesktopManager.unlock_popup_site(popup_window.popup_res)

func _on_download_pressed() -> void:
	if DesktopManager.used_hacked: return
	
	DesktopManager.used_hacked = true
	
	DesktopManager.show_popup(DesktopManager.DISC_EXTRACTING_POPUP, {
		"file_res" : HACKED_INFO,
		"type" : 1})

extends HBoxContainer

@export var popup_res: PopupResource
@export var site_name: String

@onready var site_name_label: Label = %SiteNameLabel
@onready var site_name_disabled_label: Label = %SiteNameDisabledLabel
@onready var visit_button: Button = %VisitButton

func _ready() -> void:
	var formated_site_name: String = "link://%s.com" % site_name
	site_name_label.text = formated_site_name
	site_name_disabled_label.text = formated_site_name
	visit_button.pressed.connect(_on_visit_button_pressed)
	
	DesktopManager.new_popup_site_unlocked.connect(_on_new_popup_site_unlocked)

func _on_visit_button_pressed() -> void:
	DesktopManager.show_popup(popup_res)

func _on_new_popup_site_unlocked(unlocked_popup_res: PopupResource) -> void:
	if popup_res == unlocked_popup_res:
		visit_button.disabled = false
		site_name_disabled_label.visible = false
		site_name_label.visible = true

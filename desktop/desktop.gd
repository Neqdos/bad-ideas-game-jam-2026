extends Control

@export var settings_window: FileWindow

@onready var time_label: Label = %TimeLabel
@onready var taskbar_icon_label: Label = %TaskbarIconLabel

@onready var boxes_os_button: Button = %BoxesOSButton
@onready var start_menu: VBoxContainer = %StartMenu
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton

const QUIT_RES: PopupResource = preload("uid://ddwvlde44s6h6")

const TASKBAR_ICON_LABEL_OFFSET_Y: float = 8.0
const TASKBAR_ICON_LABEL_MAX_WIDTH: float = 128.0

var last_task_bar_icon: TaskbarIcon

func _ready() -> void:
	DesktopManager.taskbar_icon_hovered.connect(_on_taskbar_icon_hovered)
	
	boxes_os_button.pressed.connect(func(): start_menu.visible = !start_menu.visible)
	settings_button.pressed.connect(func(): settings_window.open())
	quit_button.pressed.connect(func(): DesktopManager.show_popup(QUIT_RES))

func _process(_delta: float) -> void:
	var time: Dictionary = DesktopManager.get_time_dict()
	time_label.text = "%02d:%02d\n%02d.%02d.%d" % [time["hour"], time["minute"], time["day"], time["month"], time["year"]]
	
	if !start_menu.visible: return
	
	if boxes_os_button.global_position.distance_squared_to(get_global_mouse_position()) > 9216.0:
		start_menu.visible = false

func _on_taskbar_icon_hovered(taskbar_icon: TaskbarIcon) -> void:
	if is_instance_valid(taskbar_icon):
		if last_task_bar_icon != taskbar_icon:
			last_task_bar_icon = taskbar_icon
			taskbar_icon_label.text = taskbar_icon.file_res.name
			taskbar_icon_label.size = Vector2.ZERO
			
			check_taskbar_icon_label_size()
		
		taskbar_icon_label.visible = true
		
		await taskbar_icon_label.draw
		
		var pos_x: float = -taskbar_icon_label.size.x / 2.0 + taskbar_icon.size.x / 2.0
		var pos_y: float = -taskbar_icon_label.size.y - TASKBAR_ICON_LABEL_OFFSET_Y
		
		taskbar_icon_label.global_position = round(taskbar_icon.global_position + Vector2(pos_x, pos_y))
	else:
		taskbar_icon_label.visible = false


func check_taskbar_icon_label_size() -> void:
	if taskbar_icon_label.size.x > TASKBAR_ICON_LABEL_MAX_WIDTH:
		taskbar_icon_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		taskbar_icon_label.custom_minimum_size = Vector2(TASKBAR_ICON_LABEL_MAX_WIDTH, 0.0)
	else:
		taskbar_icon_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		taskbar_icon_label.custom_minimum_size = Vector2.ZERO
	taskbar_icon_label.size = Vector2.ZERO

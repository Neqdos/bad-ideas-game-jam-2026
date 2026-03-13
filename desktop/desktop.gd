extends Control

@onready var time_label: Label = %TimeLabel
@onready var taskbar_icon_label: Label = %TaskbarIconLabel

const TASKBAR_ICON_LABEL_OFFSET_Y: float = 8.0


func _ready() -> void:
	DesktopManager.taskbar_icon_hovered.connect(_on_taskbar_icon_hovered)

func _process(_delta: float) -> void:
	var time: Dictionary = DesktopManager.get_time_dict()
	time_label.text = "%02d:%02d\n%02d.%02d.%d" % [time["hour"], time["minute"], time["day"], time["month"], time["year"]]

func _on_taskbar_icon_hovered(taskbar_icon: TaskbarIcon) -> void:
	if is_instance_valid(taskbar_icon):
		taskbar_icon_label.text = taskbar_icon.file_res.name
		taskbar_icon_label.size = Vector2.ZERO
		taskbar_icon_label.visible = true
		
		await taskbar_icon_label.draw
		
		var pos_x: float = -taskbar_icon_label.size.x / 2.0 + taskbar_icon.size.x / 2.0
		var pos_y: float = -taskbar_icon_label.size.y - TASKBAR_ICON_LABEL_OFFSET_Y
		
		taskbar_icon_label.global_position = taskbar_icon.global_position + Vector2(pos_x, pos_y)
	else:
		taskbar_icon_label.visible = false

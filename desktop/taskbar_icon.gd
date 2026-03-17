extends Button
class_name TaskbarIcon

var file_res: FileResource

var window: FileWindow

var was_closed: bool = true

func _ready() -> void:
	icon = file_res.icon
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	window.closed.connect(_on_window_closed)
	window.opened.connect(_on_window_opened)

func _on_mouse_entered() -> void:
	DesktopManager.taskbar_icon_hovered.emit(self)

func _on_mouse_exited() -> void:
	DesktopManager.taskbar_icon_hovered.emit(null)

func _on_window_closed() -> void:
	visible = false
	was_closed = true

func _on_window_opened() -> void:
	if was_closed:
		get_parent().move_child(self, -1)
		was_closed = false
	visible = true

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released() and is_hovered():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if DesktopManager.currently_focused_window == window:
				window.minimize()
			else:
				window.open()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			window.close()

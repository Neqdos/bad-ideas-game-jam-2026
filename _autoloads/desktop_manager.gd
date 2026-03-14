extends Node

signal window_grab_focus(window: DesktopWindow)
signal taskbar_icon_hovered(taskbar_icon: TaskbarIcon)

signal desktop_icon_dropped(desktop_icon: DesktopIcon, from: Vector2i)

signal usb_extracting_finished()


signal climbing_input_lock(lock: bool)
signal climbing_player_death()
var climbing_spawn_area: SpawnArea
const CLIMBING_DEATH_TIME: float = .5

const DESKTOP_ICON_SCENE: PackedScene = preload("uid://d2cy4fxujo4kc")
const POPUP_WINDOW_SCENE: PackedScene = preload("uid://nhxqcrnm8ar6")


var desktop_icon_container: Control = null:
	get():
		if !is_instance_valid(desktop_icon_container): desktop_icon_container = get_tree().get_first_node_in_group("desktop_icon_container")
		return desktop_icon_container
var window_container: Control = null:
	get():
		if !is_instance_valid(window_container): window_container = get_tree().get_first_node_in_group("window_container")
		return window_container

var currently_moved_window: Control = null
var currently_focused_window: DesktopWindow

var time_minute_offset: float = 0.0

func _ready() -> void:
	window_grab_focus.connect(_on_window_grab_focus)

func _on_window_grab_focus(window: DesktopWindow) -> void:
	currently_focused_window = window


func get_file_icon_at_position(grid_pos: Vector2i) -> DesktopIcon:
	for desktop_icon: DesktopIcon in desktop_icon_container.get_children():
		if desktop_icon.grid_pos == grid_pos: return desktop_icon
	return null


## Use this to add new files later in the game.
func add_file_to_desktop(file_res: FileResource) -> void:
	var all_grid_positions: Array[Vector2i]
	
	for desktop_icon: DesktopIcon in desktop_icon_container.get_children():
		all_grid_positions.append(desktop_icon.grid_pos)
	
	var grid_pos: Vector2i = Vector2i(-1, -1)
	for y: int in range(6):
		for x: int in range(9):
			if !all_grid_positions.has(Vector2i(x, y)):
				grid_pos = Vector2i(x, y)
				break
		if grid_pos != Vector2i(-1, -1): break
	
	var new_desktop_icon: DesktopIcon = DESKTOP_ICON_SCENE.instantiate()
	new_desktop_icon.file_res = file_res
	new_desktop_icon.grid_pos = grid_pos
	desktop_icon_container.add_child(new_desktop_icon)


func show_popup(popup_res: PopupResource) -> void:
	#var popup_window: PopupWindow = _get_popup_from_resource(popup_res)
	
	#if is_instance_valid(popup_window):
		#popup_window.open()
		#popup_window.popup_scene._start()
	#else:
	var new_popup_window: PopupWindow = POPUP_WINDOW_SCENE.instantiate()
	new_popup_window.popup_res = popup_res
	window_container.add_child(new_popup_window)

func get_time_dict() -> Dictionary:
	var time: Dictionary = Time.get_datetime_dict_from_system()
	var minute: int = time["minute"] + int(time_minute_offset)
	var hour: int = time["hour"] + floori(minute / 60.0)
	time["minute"] = minute % 60 if minute % 60 >= 0 else 60 + minute % 60
	time["hour"] = hour % 24 if hour % 24 >= 0 else 24 + hour % 24
	return time

func _get_popup_from_resource(popup_res: PopupResource) -> PopupWindow:
	for window: DesktopWindow in window_container.get_children():
		if window is PopupWindow:
			if window.popup_res == popup_res:
				return window
	return null

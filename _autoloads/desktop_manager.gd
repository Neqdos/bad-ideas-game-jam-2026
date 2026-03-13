extends Node

signal window_grab_focus(window: FileWindow)
signal taskbar_icon_hovered(taskbar_icon: TaskbarIcon)

signal desktop_icon_dropped(desktop_icon: DesktopIcon, from: Vector2i)

const DESKTOP_ICON_SCENE = preload("uid://d2cy4fxujo4kc")

var desktop_icon_container: Control = null:
	get():
		if !is_instance_valid(desktop_icon_container): desktop_icon_container = get_tree().get_first_node_in_group("desktop_icon_container")
		return desktop_icon_container


var currently_moved_window: Control = null
var currently_focused_window: FileWindow


func _ready() -> void:
	window_grab_focus.connect(_on_window_grab_focus)

func _on_window_grab_focus(window: FileWindow) -> void:
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

extends Node
@warning_ignore_start("unused_signal")

signal window_grab_focus(window: DesktopWindow)
signal taskbar_icon_hovered(taskbar_icon: TaskbarIcon)

signal desktop_icon_dropped(desktop_icon: DesktopIcon, from: Vector2i)

signal desktop_icon_added(desktop_icon: DesktopIcon)

signal disc_extracting_finished()

signal new_popup_site_unlocked(popup_res: PopupResource)

signal safe_ui_open()
signal safe_opened()

# CLIMBING
signal climbing_input_lock(lock: bool)
signal climbing_player_death()
signal climbing_transition(visible: bool, time: float)
signal climbing_transition_finished()
var climbing_spawn_area: SpawnArea
var max_hook_travel_distance: float = 8.0
# ---

# FISHING
signal fishing_game_started()
signal fishing_game_reeling()
signal fishing_game_ended()
signal fishing_all_sold()

signal fishing_money_changed()
var fishing_hook: FishingHook
var fishing_game_is_going: bool = false
var fishing_money: float = 0.0:
	set(val):
		fishing_money = val
		fishing_money_changed.emit()
var fishing_stats: FishingStats = FishingStats.new()
var fishing_compendium: Array[FishResource] = []
var shown_course_popup: bool = false
# ---

# RPG

# ---

# 3D OBJECTS
signal power_off()
signal power_on()
signal gravity_changed()
signal spawn_hammer()
var can_enter_and_exit_computer: bool = false
var safe_code: String
var is_magnet_on: bool = false
var reversed_gravity: bool = false:
	set(val):
		reversed_gravity = val
		gravity_changed.emit()
var reversed_gravity_strength: float:
	get:
		return -float(DesktopManager.reversed_gravity) * 2.0 + 1.0

# ---

var sound_pos: Vector3

var is_using_clock: bool = false
var paint_tiles: Array[Array]
signal paint_tiles_changed()

var unlocked_popup_sites: Array[PopupResource]
var used_hacked: bool = false
var used_online_course: bool = false

const DESKTOP_AUDIO_ICON = preload("uid://bnj0g6vpwpmb5")
const DESKTOP_AUDIO_ICON_MUTE = preload("uid://crlq0jw43me41")


const DESKTOP_ICON_SCENE: PackedScene = preload("uid://d2cy4fxujo4kc")
const POPUP_WINDOW_SCENE: PackedScene = preload("uid://nhxqcrnm8ar6")
const DISC_EXTRACTING_POPUP: PopupResource = preload("uid://khve0uqaqspc")

const TITLE_BAR_COLOR_TO_TEXTURE: Dictionary[FileResource.TITLE_BAR_COLOR, Texture2D] = {
	FileResource.TITLE_BAR_COLOR.Black : preload("uid://dgqj4co82fad6"),
	FileResource.TITLE_BAR_COLOR.White : preload("uid://b3i6111k5g7ob"),
	FileResource.TITLE_BAR_COLOR.Blue : preload("uid://uud3gp5runin"),
	FileResource.TITLE_BAR_COLOR.Red : preload("uid://b6g553k1w2vvb"),
	FileResource.TITLE_BAR_COLOR.Yellow : preload("uid://dwnt5rouq8qv6"),
	FileResource.TITLE_BAR_COLOR.Green : preload("uid://bngoxw5yjtxua"),
	
}

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
	
	safe_code = str(randi_range(1000, 9999))

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
	
	desktop_icon_added.emit(new_desktop_icon)


func show_popup(popup_res: PopupResource, data: Dictionary[String, Variant] = {}) -> void:
	var new_popup_window: PopupWindow = POPUP_WINDOW_SCENE.instantiate()
	new_popup_window.popup_res = popup_res
	new_popup_window.data = data
	window_container.add_child(new_popup_window)

func unlock_popup_site(popup_res: PopupResource) -> void:
	if unlocked_popup_sites.has(popup_res): return
	
	unlocked_popup_sites.append(popup_res)
	new_popup_site_unlocked.emit(popup_res)

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

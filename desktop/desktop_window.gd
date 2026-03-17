@abstract
extends Control
class_name DesktopWindow

signal closed()
signal opened()

@export var focus_detection: TextureButton
@export var window_panel: PanelContainer
@export var title_bar: TextureButton

@export var app_viewport: SubViewport

const LIMIT_OFFSET: Vector2 = Vector2(16.0, 52.0)

const ROTATION_LERP: float = 12.0
const POSITION_LERP: float = 16.0

var move_offset: Vector2

@abstract
func initiate() -> void

func _base_ready() -> void:
	visible = false
	
	focus_detection.button_down.connect(_on_focus_detection_button_down)
	DesktopManager.window_grab_focus.connect(_on_window_grab_focus)
	
	title_bar.button_down.connect(func(): DesktopManager.window_grab_focus.emit(self))
	
	initiate()

func _base_process(delta: float) -> void:
	if DesktopManager.currently_moved_window == self:
		if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			DesktopManager.currently_moved_window = null
			return
		var old_global_pos: Vector2 = global_position
		global_position = global_position.lerp(get_global_mouse_position() - move_offset, POSITION_LERP * delta)
		global_position.x = clampf(global_position.x, 0.0, 640.0 - LIMIT_OFFSET.x)
		global_position.y = clampf(global_position.y, 0.0, 480.0 - LIMIT_OFFSET.y)
		set_window_rotation((global_position.x - old_global_pos.x) * 2.0, delta)
	else:
		set_window_rotation(0.0, delta)
	if title_bar.is_hovered() and Input.is_action_just_pressed("mouse_left_click"):
		if is_instance_valid(DesktopManager.currently_moved_window): return
		DesktopManager.currently_moved_window = self
		move_offset = get_global_mouse_position() - global_position
		window_panel.pivot_offset = move_offset

func set_window_rotation(rot: float, delta: float) -> void:
	window_panel.rotation_degrees = lerpf(window_panel.rotation_degrees, rot, ROTATION_LERP * delta)


func _on_window_grab_focus(window: DesktopWindow) -> void:
	app_viewport.gui_disable_input = window != self
	focus_detection.visible = window != self
	if window == self: get_parent().move_child(self, -1)

func _on_focus_detection_button_down() -> void:
	DesktopManager.window_grab_focus.emit(self)

func minimize() -> void:
	visible = false
	DesktopManager.window_grab_focus.emit(null)

func close() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	visible = false
	DesktopManager.window_grab_focus.emit(null)
	
	position_to_center()
	
	closed.emit()

func open() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true
	DesktopManager.window_grab_focus.emit(self)
	
	opened.emit()

func position_to_center() -> void:
	global_position = round(Vector2(320.0, 240.0) - (window_panel.size / 2.0))

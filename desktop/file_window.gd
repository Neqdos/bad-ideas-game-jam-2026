extends PanelContainer
class_name FileWindow

signal closed()
signal opened()

@onready var focus_detection: TextureButton = %FocusDetection

@onready var title_bar: TextureButton = %TitleBar
@onready var window_icon: TextureRect = %WindowIcon
@onready var window_name: Label = %WindowName

@onready var minimize_button: Button = %MinimizeButton
@onready var close_button: Button = %CloseButton

@onready var app_viewport: SubViewport = %AppViewport

const LIMIT_OFFSET: Vector2 = Vector2(16.0, 64.0)

var move_offset: Vector2

var file_res: FileResource

func initiate() -> void:
	window_name.text = file_res.name
	window_icon.texture = file_res.icon
	
	app_viewport.size = file_res.window_size
	
	# this is probably not the best way to do it, but it works.
	if file_res is AppFileResource:
		var new_app_scene: Node = file_res.scene.instantiate()
		app_viewport.add_child(new_app_scene)
	elif file_res is TextFileResource:
		var new_text_scene: TextFileScene = file_res.SCENE.instantiate()
		new_text_scene.data = file_res.data
		app_viewport.add_child(new_text_scene)
	elif file_res is ImageFileResource:
		var new_image_scene: ImageFileScene = file_res.SCENE.instantiate()
		new_image_scene.image = file_res.image
		opened.connect(new_image_scene.reset)
		app_viewport.add_child(new_image_scene)
	
	await get_tree().process_frame
	
	close()

func _ready() -> void:
	close_button.pressed.connect(close)
	minimize_button.pressed.connect(minimize)
	
	focus_detection.button_down.connect(_on_focus_detection_button_down)
	
	DesktopManager.window_grab_focus.connect(_on_window_grab_focus)
	
	initiate()

func _process(_delta: float) -> void:
	if DesktopManager.currently_moved_window == self:
		if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			DesktopManager.currently_moved_window = null
			return
		global_position = get_global_mouse_position() - move_offset
		global_position.x = clampf(global_position.x, 0.0, 640.0 - LIMIT_OFFSET.x)
		global_position.y = clampf(global_position.y, 0.0, 480.0 - LIMIT_OFFSET.y)
	
	if title_bar.is_hovered() and Input.is_action_just_pressed("mouse_left_click"):
		if is_instance_valid(DesktopManager.currently_moved_window): return
		DesktopManager.currently_moved_window = self
		move_offset = get_global_mouse_position() - global_position

func _on_window_grab_focus(window: FileWindow) -> void:
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
	
	global_position = Vector2(320.0, 240.0) - (size / 2.0)
	
	closed.emit()

func open() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true
	DesktopManager.window_grab_focus.emit(self)
	
	opened.emit()

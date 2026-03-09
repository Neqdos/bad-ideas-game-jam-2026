@tool
extends Control
class_name DesktopIcon

@export var file_res: FileResource:
	set(val):
		file_res = val
		set_icon_and_name()

@export var grid_pos: Vector2i:
	set(val):
		grid_pos.x = clampi(val.x, 0, MAX_GRID_POS.x)
		grid_pos.y = clampi(val.y, 0, MAX_GRID_POS.y)
		global_position = Vector2(grid_pos) * Vector2(TILE_SIZE, TILE_SIZE)


@onready var panel_container: PanelContainer = %PanelContainer

@onready var file_icon: TextureRect = %FileIcon
@onready var file_name: Label = %FileName
@onready var mouse_detection: TextureButton = %MouseDetection

const TILE_SIZE: float = 64.0

const MAX_GRID_POS: Vector2i = Vector2i(9, 6)

const FILE_WINDOW_SCENE = preload("uid://wr7j6c1jo6j2")
const TASK_BAR_ICON_SCENE = preload("uid://bvtr7dqhmh358")

var window: FileWindow


var is_pressed: bool = false
var is_being_moved: bool = false
var move_offset: Vector2


func _ready() -> void:
	set_icon_and_name()
	
	if Engine.is_editor_hint(): return
	
	mouse_detection.pressed.connect(_on_pressed)
	
	mouse_detection.mouse_entered.connect(_on_mouse_entered)
	mouse_detection.mouse_exited.connect(_on_mouse_exited)
	
	mouse_detection.button_down.connect(_on_button_down)
	mouse_detection.button_up.connect(_on_button_up)
	
	
	var window_container: Control = get_tree().get_first_node_in_group("window_container")
	var task_bar: Control = get_tree().get_first_node_in_group("taskbar")
	
	window = FILE_WINDOW_SCENE.instantiate()
	window.file_res = file_res
	window_container.add_child.call_deferred(window)
	
	var new_task_bar_icon: TaskbarIcon = TASK_BAR_ICON_SCENE.instantiate()
	new_task_bar_icon.file_res = file_res
	new_task_bar_icon.window = window
	new_task_bar_icon.visible = false
	task_bar.add_child.call_deferred(new_task_bar_icon)
	
	position_to_grid()

func position_to_grid() -> void:
	var new_grid_pos: Vector2i = get_grid_pos_from_position()
	
	var found_file_icon: DesktopIcon = DesktopManager.get_file_icon_at_position(new_grid_pos)
	
	if is_instance_valid(found_file_icon):
		found_file_icon.grid_pos = grid_pos
	
	grid_pos = new_grid_pos

func get_grid_pos_from_position() -> Vector2i:
	return (global_position / TILE_SIZE).round()


func set_icon_and_name() -> void:
	if !is_node_ready(): await ready
	if !is_instance_valid(file_res): return
	
	file_icon.texture = file_res.icon
	file_name.text = file_res.name


func _on_mouse_entered() -> void:
	file_name.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
	panel_container.self_modulate.a = .5
	get_parent().move_child(self, -1)

func _on_mouse_exited() -> void:
	file_name.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	panel_container.self_modulate.a = 0.0


func _on_pressed() -> void:
	if !is_being_moved: window.open()

func _on_button_down() -> void:
	move_offset = get_global_mouse_position() - global_position
	is_pressed = true

func _on_button_up() -> void:
	is_pressed = false
	
	if is_being_moved:
		is_being_moved = false
		position_to_grid()

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if is_being_moved:
		global_position = get_global_mouse_position() - move_offset
	elif is_pressed and move_offset.distance_squared_to(get_global_mouse_position() - global_position) > 16.0:
		is_being_moved = true

extends Area2D
class_name FileTile

signal file_placed()

@export var file_res: FileResource

@onready var icon: Sprite2D = %Icon

var is_hovered: bool = false

var icon_grayscale_shader: ShaderMaterial

func _ready() -> void:
	DesktopManager.desktop_icon_dropped.connect(_on_desktop_icon_dropped)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	icon_grayscale_shader = icon.material
	icon.texture = file_res.icon

func _on_mouse_entered() -> void:
	is_hovered = true

func _on_mouse_exited() -> void:
	is_hovered = false

func _on_desktop_icon_dropped(desktop_icon: DesktopIcon, from: Vector2i) -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	if !is_hovered: return
	if desktop_icon.file_res != file_res: return
	
	icon_grayscale_shader.set_shader_parameter("is_on", false)
	file_placed.emit()
	
	desktop_icon.move_to_pos(from)

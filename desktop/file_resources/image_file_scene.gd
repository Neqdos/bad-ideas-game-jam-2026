extends Node2D
class_name ImageFileScene

@onready var image_sprite: Sprite2D = %ImageSprite
@onready var camera: Camera2D = %Camera


var image: Texture2D

const OFFSET: float = 16.0

var is_moving: bool = false

func _ready() -> void:
	image_sprite.texture = image

func reset() -> void:
	camera.position = Vector2.ZERO
	
	var zoom: float = 400.0 / image.get_size().length()
	camera.zoom = Vector2(zoom, zoom)
	
	is_moving = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left_click"):
		is_moving = true
	elif event.is_action_released("mouse_left_click"):
		is_moving = false
	
	if event is InputEventMouseMotion:
		if !is_moving: return
		
		camera.global_position -= event.relative * (1.0 / camera.zoom.x)
	
	if event.is_action_pressed("scroll_up"):
		camera.zoom *= 1.1
	elif event.is_action_pressed("scroll_down"):
		camera.zoom *= 0.9

extends Node3D
class_name GUIPanel

@export var viewport: SubViewport
@export var quad: MeshInstance3D
@export var area: Area3D

@export var active: bool = false

var player: PlayerBody:
	set(val):
		viewport.get_child(0).set("player", val)

var is_mouse_inside: bool = false

var last_event_position: Vector2 = Vector2.ZERO
var last_event_time: float = -1.0

func _ready() -> void:
	area.mouse_entered.connect(_on_area_mouse_entered)
	area.mouse_exited.connect(_on_area_mouse_exited)
	area.input_event.connect(_area_input_event)


func _on_area_mouse_entered() -> void:
	is_mouse_inside = true

func _on_area_mouse_exited() -> void:
	is_mouse_inside = false


func _unhandled_key_input(event: InputEvent) -> void:
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event):
			return
	
	viewport.push_input(event)


func _area_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if !active: return
	
	var quad_mesh_size: Vector2 = quad.mesh.size
	
	var current_time: float = Time.get_ticks_msec() / 1000.0
	
	event_position = quad.global_transform.affine_inverse() * event_position
	
	var event_position_2d: Vector2 = Vector2.ZERO
	
	if is_mouse_inside:
		event_position_2d = Vector2(event_position.x, -event_position.y)
		event_position_2d = event_position_2d / quad_mesh_size
		event_position_2d += Vector2(.5, .5)
		event_position_2d *= Vector2(viewport.size)
	elif last_event_position:
		event_position_2d = last_event_position
	
	event.position = event_position_2d
	if event is InputEventMouse:
		event.global_position = event_position_2d
	
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if last_event_time >= 0.0:
			event.relative = event_position_2d - last_event_position
			event.velocity = event.relative / (current_time - last_event_time)
		else:
			event.relative = Vector2.ZERO
			event.velocity = Vector2.ZERO
	
	last_event_position = event_position_2d
	last_event_time = current_time
	
	viewport.push_input(event)

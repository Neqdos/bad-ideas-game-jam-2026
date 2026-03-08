extends Control


@export var player: PlayerBody

@onready var action_container: VBoxContainer = %ActionContainer

@onready var panel: Panel = %Panel
@onready var panel_corners: NinePatchRect = %PanelCorners
@onready var object_name_label: Label = %ObjectNameLabel
@onready var info_label: Label = %InfoLabel


@onready var point_line: Line2D = %PointLine

const input_action_names_to_string: Dictionary[String, String] = {
	"object_move" = "E",
	"object_interact" = "F",
	"object_hold" = "Q",
	"object_pick_up" = "R",
}

const OFFSET_MIN_X: float = 64.0
const OFFSET_MAX_X: float = 64.0
const OFFSET_MIN_Y: float = 0.0
const OFFSET_MAX_Y: float = 16.0

const PANEL_SMOOTHING: float = 16.0
const INITIAL_PANEL_SIZE_MULT: float = 1.5

const DEFAULT_LINE_POINT_OFFSET: float = 2.0
const DEFAULT_LINE_SCALE: float = 1.0
const INITIAL_LINE_SCALE: float = 8.0
const LINE_SMOOTHING: float = 12.0

var line_scale: float = DEFAULT_LINE_SCALE

var object_meshes: Array[MeshInstance3D]
var object_info_label: ObjectInfoLabel

func _ready() -> void:
	visible = false
	
	player.player_interaction_ray.hovered.connect(_on_hovered)
	player.player_interaction_ray.unhovered.connect(_on_unhovered)
	
	panel.self_modulate.a = 0.0
	panel_corners.self_modulate.a = 0.0
	
	_on_unhovered()

func _on_hovered() -> void:
	visible = false
	
	for c in action_container.get_children():
		c.queue_free()
	
	
	object_name_label.text = ""
	
	var has_actions: bool = false
	
	if is_instance_valid(player.player_interaction_ray.object):
		add_label("Pick up - E")
		object_name_label.text = player.player_interaction_ray.object.obj_resource.name
		has_actions = true
	
	for action: ObjectInteractAction in player.player_interaction_ray.interactable.find_children("", "ObjectInteractAction", false, false):
		has_actions = true
		add_label("%s - %s" % [action.action_text, input_action_names_to_string[action.input_action_name]])
	
	var obj_info_label: ObjectInfoLabel = GlobalMethods.find_first_child_of_type(player.player_interaction_ray.interactable, ObjectInfoLabel)
	if is_instance_valid(obj_info_label):
		object_info_label = obj_info_label
		info_label.visible = true
		has_actions = true
	else:
		object_info_label = null
		info_label.visible = false
	
	if !has_actions: return
	
	object_meshes.clear()
	object_meshes = GlobalMethods.get_correct_meshes_from_a_node(player.player_interaction_ray.interactable)
	old_object_transform = Transform3D()
	
	set_line(0.0)
	visible = true

func add_label(text: String) -> void:
	var new_label: Label = Label.new()
	new_label.text = text
	new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	action_container.add_child(new_label)

func _on_unhovered() -> void:
	visible = false
	object_meshes.clear()
	info_label.text = ""
	info_label.size = Vector2.ZERO

func _process(delta: float) -> void:
	if !visible: return
	if is_instance_valid(player.player_interaction_ray.grabbed_object): visible = false
	
	
	set_line(delta)
	
	if is_instance_valid(object_info_label):
		info_label.size = Vector2.ZERO
		info_label.text = object_info_label.info

func set_line(delta: float) -> void:
	if object_meshes and is_instance_valid(player.player_interaction_ray.interactable):
		var convex_points: PackedVector2Array = get_convex_points_from_vertices(player.player_interaction_ray.interactable, object_meshes)
		
		point_line.clear_points()
		
		if convex_points:
			convex_points = Geometry2D.offset_polygon(convex_points, DEFAULT_LINE_POINT_OFFSET, Geometry2D.PolyJoinType.JOIN_ROUND)[0]
			
			var centroid: Vector2 = get_polygon_centroid(convex_points)
			
			if delta:
				line_scale = lerpf(line_scale, DEFAULT_LINE_SCALE, delta * LINE_SMOOTHING)
			else:
				var polygon_size: float = get_polygon_size(convex_points, centroid)
				line_scale = (polygon_size + INITIAL_LINE_SCALE) / polygon_size
			
			
			for point: Vector2 in convex_points:
				point_line.add_point(point - centroid)
			
			point_line.position = centroid
			point_line.scale = Vector2(line_scale, line_scale)
			
			
			var rect: Rect2 = get_rect2_from_points(convex_points)
			panel.size = rect.size
			panel.position = rect.position
			
			panel.visible = true
		else:
			panel.visible = false
	else:
		panel.visible = false


var old_object_transform: Transform3D
var object_vertices: Array[Vector3]

func calculate_vertices(all_meshes: Array[MeshInstance3D]) -> void:
	object_vertices.clear()
	
	for mesh_instance: MeshInstance3D in all_meshes:
		var mesh: Mesh = mesh_instance.mesh
		if !mesh: continue
		
		var global_transform: Transform3D = mesh_instance.global_transform
		
		for i: int in mesh.get_surface_count():
			var arrays: Array = mesh.surface_get_arrays(i)
			var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
			
			for local_vertex: Vector3 in vertices:
				object_vertices.append(global_transform * local_vertex)

func get_convex_points_from_vertices(node: Node3D, all_meshes: Array[MeshInstance3D]) -> PackedVector2Array:
	var all_behind: bool = true
	
	if !node.global_transform.is_equal_approx(old_object_transform):
		old_object_transform = node.global_transform
		calculate_vertices(all_meshes)
	
	var unporjected_vertices: Array[Vector2]
	
	for vertex: Vector3 in object_vertices:
		if player.camera.is_position_behind(vertex): continue
		
		var point_2d: Vector2 = player.camera.unproject_position(vertex)
		unporjected_vertices.append(point_2d)
		
		all_behind = false
	
	if all_behind: return []
	
	return Geometry2D.convex_hull(unporjected_vertices)

func get_polygon_centroid(points: PackedVector2Array) -> Vector2:
	var sum: Vector2 = Vector2.ZERO
	var amount: float = points.size()
	
	for point: Vector2 in points:
		sum += point
	
	return sum / amount

func get_polygon_size(points: PackedVector2Array, centroid: Vector2) -> float:
	var polygon_size: float = 0.0
	
	for point: Vector2 in points:
		var length: float = (point - centroid).length_squared()
		if length > polygon_size: polygon_size = length
	
	return sqrt(polygon_size)

func get_rect2_from_points(points: Array[Vector2]) -> Rect2:
	var viewport_size: Vector2 = get_viewport_rect().size
	
	var min_x: float = INF
	var min_y: float = INF
	var max_x: float = -INF
	var max_y: float = -INF
	
	for point: Vector2 in points:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
	
	min_x = max(min_x, OFFSET_MIN_X)
	min_y = max(min_y, OFFSET_MIN_Y)
	max_x = min(max_x, viewport_size.x - OFFSET_MAX_X)
	max_y = min(max_y, viewport_size.y - OFFSET_MAX_Y)
	
	return Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))

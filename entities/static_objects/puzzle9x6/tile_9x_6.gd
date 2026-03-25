extends AnimatableBody3D
class_name Tile9x6

@onready var desktop_icon_mesh: MeshInstance3D = %DesktopIconMesh

const OFFSET: Vector3 = Vector3(.5, 0.0, .5)

var desktop_icon: DesktopIcon

func _ready() -> void:
	desktop_icon.moved.connect(sync_position)
	
	var mat: StandardMaterial3D = desktop_icon_mesh.material_override
	mat.albedo_texture = desktop_icon.file_res.icon

func sync_position() -> void:
	position = Vector3(desktop_icon.grid_pos.x, 0.0, desktop_icon.grid_pos.y) + OFFSET

func check_visibility(powered: bool) -> void:
	visible = powered

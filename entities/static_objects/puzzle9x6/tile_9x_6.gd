extends AnimatableBody3D
class_name Tile9x6

@onready var desktop_icon_mesh: MeshInstance3D = %DesktopIconMesh

var desktop_icon: DesktopIcon

func _ready() -> void:
	desktop_icon.moved.connect(sync_position)
	
	var mat: StandardMaterial3D = desktop_icon_mesh.material_override
	mat.albedo_texture = desktop_icon.file_res.icon

func sync_position() -> void:
	position.x = desktop_icon.grid_pos.x * 1.0
	position.z = desktop_icon.grid_pos.y * 1.0

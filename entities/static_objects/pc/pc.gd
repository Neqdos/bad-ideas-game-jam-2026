extends StaticBody3D
class_name PCObject

@onready var object_interact_action: ObjectInteractAction = %ObjectInteractAction

@onready var gui_panel: GUIPanel = %GUIPanel
@onready var camera_marker: Marker3D = %CameraMarker

@onready var detection_area: Area3D = %DetectionArea


var current_user: PlayerBody

func _ready() -> void:
	object_interact_action.interacted.connect(_on_object_interact_action_interacted)

func _on_object_interact_action_interacted(player: PlayerBody) -> void:
	current_user = player
	SignalManager.enter_screen(camera_marker.global_transform, detection_area, player, gui_panel)

func _unhandled_input(event: InputEvent) -> void:
	if !is_instance_valid(current_user): return
	
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		SignalManager.exit_screen(detection_area, current_user, gui_panel)
		DesktopManager.window_grab_focus.emit(null)
		current_user = null

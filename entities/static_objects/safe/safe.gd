extends Node3D

@onready var door_body: AnimatableBody3D = %DoorBody
@onready var door_interact_action: ObjectInteractAction = %DoorInteractAction

const OPEN_ROTATION: float = 135.0

var is_open: bool = false

var tween: Tween

func _ready() -> void:
	door_interact_action.interacted.connect(_on_door_interact_action_interacted)
	
	DesktopManager.safe_opened.connect(_on_safe_opened)

func _on_door_interact_action_interacted(player: PlayerBody) -> void:
	if is_open: return
	
	DesktopManager.safe_ui_open.emit()

func _on_safe_opened() -> void:
	is_open = true
	
	door_interact_action.queue_free()
	
	tween = get_tree().create_tween()
	tween.tween_property(door_body, "rotation_degrees:y", OPEN_ROTATION, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	

extends StaticBody3D

@onready var object_interact_action: ObjectInteractAction = %ObjectInteractAction
@onready var gravity_sphere: MeshInstance3D = %GravitySphere

const POS_Y_ON: float = 0.438
const POS_Y_OFF: float = 0.062

const TWEEN_TIME: float = 1.0

var can_be_used: bool = true

var tween: Tween

func _ready() -> void:
	object_interact_action.interacted.connect(_on_object_interact_action_interacted)

func _on_object_interact_action_interacted(player: PlayerBody) -> void:
	if !can_be_used: return
	can_be_used = false
	
	SignalManager.camera_lock.emit(true)
	SignalManager.player_input_lock.emit(true)
	
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(gravity_sphere, "position:y", POS_Y_ON if !DesktopManager.reversed_gravity else POS_Y_OFF, TWEEN_TIME)
	
	await tween.finished
	
	SignalManager.camera_lock.emit(false)
	SignalManager.player_input_lock.emit(false)
	
	DesktopManager.reversed_gravity = !DesktopManager.reversed_gravity
	can_be_used = true

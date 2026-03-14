extends DesktopWindow
class_name PopupWindow

@onready var close_button: Button = %CloseButton

var popup_res: PopupResource

func initiate() -> void:
	app_viewport.size = popup_res.window_size
	
	var popup_scene: Node = popup_res.scene.instantiate()
	app_viewport.add_child(popup_scene)
	
	name = popup_scene.name
	
	await get_tree().process_frame
	
	position_to_center()
	open()

func _ready() -> void:
	_base_ready()
	
	if !popup_res.can_be_closed_manually:
		close_button.visible = false
	close_button.pressed.connect(close)
	
	closed.connect(_on_closed)

func _process(delta: float) -> void:
	_base_process(delta)

func _on_closed() -> void:
	queue_free.call_deferred()

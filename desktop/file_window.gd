extends DesktopWindow
class_name FileWindow


@onready var window_icon: TextureRect = %WindowIcon
@onready var window_name: Label = %WindowName

@onready var minimize_button: Button = %MinimizeButton
@onready var close_button: Button = %CloseButton


var file_res: FileResource

func initiate() -> void:
	name = file_res.name.to_pascal_case()
	
	window_name.text = file_res.name
	window_icon.texture = file_res.icon
	
	app_viewport.size = file_res.window_size
	
	# this is probably not the best way to do it, but it works.
	if file_res is AppFileResource:
		var new_app_scene: Node = file_res.scene.instantiate()
		app_viewport.add_child(new_app_scene)
	elif file_res is TextFileResource:
		var new_text_scene: TextFileScene = file_res.SCENE.instantiate()
		new_text_scene.data = file_res.data
		app_viewport.add_child(new_text_scene)
	elif file_res is ImageFileResource:
		var new_image_scene: ImageFileScene = file_res.SCENE.instantiate()
		new_image_scene.image = file_res.image
		opened.connect(new_image_scene.reset)
		app_viewport.add_child(new_image_scene)
	
	await get_tree().process_frame
	
	close()

func _ready() -> void:
	_base_ready()
	
	close_button.pressed.connect(close)
	minimize_button.pressed.connect(minimize)

func _process(delta: float) -> void:
	_base_process(delta)

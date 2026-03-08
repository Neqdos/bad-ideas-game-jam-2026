extends Control

const MAIN_MENU_SCENE_PATH: String = "uid://dedbgh2tbscnu"

@onready var settings: SettingsUI = %Settings
@onready var quit_to_main_menu_button: Button = %QuitToMainMenuButton

func _ready() -> void:
	settings.apply_button.pressed.connect(func(): change_visibility(false))
	quit_to_main_menu_button.pressed.connect(_on_quit_to_main_menu_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		await get_tree().process_frame
		if get_viewport().is_input_handled(): return
		
		change_visibility(!visible)

func change_visibility(state: bool) -> void:
	visible = state
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if state else Input.MOUSE_MODE_CAPTURED
	SignalManager.camera_lock.emit(state)
	SignalManager.player_input_lock.emit(state)

func _on_quit_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)

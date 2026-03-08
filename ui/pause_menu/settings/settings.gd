extends Control
class_name SettingsUI

@onready var fullscreen: CheckBox = %Fullscreen
@onready var vsync: CheckBox = %VSync
@onready var max_fps: OptionButton = %MaxFps
@onready var sensitivity: SpinBox = %Sensitivity
@onready var reset_sensitivity_button: Button = %ResetSensitivityButton

@onready var apply_button: Button = %ApplyButton



func _ready() -> void:
	apply_button.pressed.connect(_on_apply_button_pressed)
	
	fullscreen.toggled.connect(_on_fullscreen_toggled)
	vsync.toggled.connect(_on_vsync_toggled)
	max_fps.item_selected.connect(_on_max_fps_item_selected)
	sensitivity.value_changed.connect(_on_sensitivity_value_changed)
	reset_sensitivity_button.pressed.connect(_on_reset_sensitivity_button_pressed)
	
	sync_ui_with_settings()

func sync_ui_with_settings() -> void:
	fullscreen.button_pressed = SaveManager.settings.fullscreen
	vsync.button_pressed = SaveManager.settings.vsync
	max_fps.selected = SaveManager.settings.max_fps
	sensitivity.value = SaveManager.settings.sensitivity


func _on_apply_button_pressed() -> void:
	SaveManager.save_settings()
	SaveManager.settings.apply()


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	SaveManager.settings.fullscreen = toggled_on

func _on_vsync_toggled(toggled_on: bool) -> void:
	SaveManager.settings.vsync = toggled_on

func _on_max_fps_item_selected(index: int) -> void:
	SaveManager.settings.max_fps = index

func _on_sensitivity_value_changed(value: float) -> void:
	SaveManager.settings.sensitivity = value

func _on_reset_sensitivity_button_pressed() -> void:
	SaveManager.settings.sensitivity = SettingsResource.DEFAULT_SENSITIVITY
	sensitivity.value = SaveManager.settings.sensitivity

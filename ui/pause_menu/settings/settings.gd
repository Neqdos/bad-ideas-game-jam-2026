extends Control
class_name SettingsUI

@onready var fullscreen: CheckBox = %Fullscreen
@onready var vsync: CheckBox = %VSync
@onready var max_fps: OptionButton = %MaxFps
@onready var sensitivity: SpinBox = %Sensitivity
@onready var reset_sensitivity_button: Button = %ResetSensitivityButton

@onready var master_volume: HSlider = %MasterVolume
@onready var master_volume_label: Label = %MasterVolumeLabel
@onready var music_volume_label: Label = %MusicVolumeLabel
@onready var music_volume: HSlider = %MusicVolume
@onready var sfx_volume_label: Label = %SFXVolumeLabel
@onready var sfx_volume: HSlider = %SFXVolume

@onready var apply_button: Button = %ApplyButton


func _ready() -> void:
	apply_button.pressed.connect(_on_apply_button_pressed)
	
	fullscreen.toggled.connect(_on_fullscreen_toggled)
	vsync.toggled.connect(_on_vsync_toggled)
	max_fps.item_selected.connect(_on_max_fps_item_selected)
	sensitivity.value_changed.connect(_on_sensitivity_value_changed)
	reset_sensitivity_button.pressed.connect(_on_reset_sensitivity_button_pressed)
	master_volume.value_changed.connect(_on_master_volume_value_changed)
	music_volume.value_changed.connect(_on_music_volume_value_changed)
	sfx_volume.value_changed.connect(_on_sfx_volume_value_changed)
	
	sync_ui_with_settings()

func sync_ui_with_settings() -> void:
	fullscreen.button_pressed = SaveManager.settings.fullscreen
	vsync.button_pressed = SaveManager.settings.vsync
	max_fps.selected = SaveManager.settings.max_fps
	sensitivity.value = SaveManager.settings.sensitivity
	
	master_volume.value = SaveManager.settings.master_volume
	music_volume.value = SaveManager.settings.music_volume
	sfx_volume.value = SaveManager.settings.sfx_volume
	#master_volume_label.text = str(SaveManager.settings.master_volume)
	#music_volume_label.text = str(SaveManager.settings.music_volume)
	#sfx_volume_label.text = str(SaveManager.settings.sfx_volume)


func _on_apply_button_pressed() -> void:
	SaveManager.save_settings()
	SaveManager.settings.apply()


func _on_master_volume_value_changed(val: float) -> void:
	SaveManager.settings.master_volume = val
	master_volume_label.text = str(val)

func _on_music_volume_value_changed(val: float) -> void:
	SaveManager.settings.music_volume = val
	music_volume_label.text = str(val)

func _on_sfx_volume_value_changed(val: float) -> void:
	SaveManager.settings.sfx_volume = val
	sfx_volume_label.text = str(val)

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

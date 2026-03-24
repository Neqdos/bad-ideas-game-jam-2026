extends Node3D

@export var room_lamp: OmniLight3D

@onready var power_switch_action: ObjectInteractAction = %PowerSwitchAction

@onready var power_off_timer: Timer = %PowerOffTimer
@onready var power_off_light: OmniLight3D = %PowerOffLight
@onready var alarm: AudioStreamPlayer3D = %Alarm


var is_power_off: bool = false

func _ready() -> void:
	DesktopManager.power_off.connect(_on_power_off)
	
	power_switch_action.interacted.connect(_on_power_switch_action_interacted)
	power_off_timer.timeout.connect(_on_power_off_timer_timeout)

func _on_power_off() -> void:
	is_power_off = true
	power_off_light.visible = true
	alarm.play()
	power_off_timer.start()
	room_lamp.visible = false

func _on_power_switch_action_interacted(player: PlayerBody) -> void:
	if !is_power_off: return
	is_power_off = false
	power_off_light.visible = false
	power_off_timer.stop()
	room_lamp.visible = true
	DesktopManager.can_enter_and_exit_computer = true
	DesktopManager.power_on.emit()

func _on_power_off_timer_timeout() -> void:
	if !is_power_off: return
	
	power_off_light.visible = !power_off_light.visible
	power_off_timer.start()
	if power_off_light.visible: alarm.play()

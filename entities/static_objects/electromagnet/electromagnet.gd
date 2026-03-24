extends Node3D

@export var battery_slot: BatterySlot

func _ready() -> void:
	battery_slot.powered_changed.connect(_on_battery_slot_powered_changed)

func _on_battery_slot_powered_changed() -> void:
	DesktopManager.is_magnet_on = battery_slot.powered

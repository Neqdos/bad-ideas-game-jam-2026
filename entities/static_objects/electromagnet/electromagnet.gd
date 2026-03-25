extends Node3D
class_name Electromagnet

@onready var battery_slot: BatterySlot = %BatterySlot
@onready var base_body: AnimatableBody3D = %BaseBody


func _ready() -> void:
	battery_slot.powered_changed.connect(_on_battery_slot_powered_changed)

func _on_battery_slot_powered_changed() -> void:
	DesktopManager.is_magnet_on = battery_slot.powered

func move() -> void:
	base_body.position.y = -0.8
	battery_slot.position.y = -0.2

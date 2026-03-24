extends StaticBody3D
class_name BatterySlot

signal powered_changed()

var powered: bool = false:
	set(val):
		powered = val
		powered_changed.emit()

@onready var battery_transform: Marker3D = %BatteryTransform
@onready var insert_sfx: AudioStreamPlayer3D = %InsertSFX

func _ready() -> void:
	child_exiting_tree.connect(battery_taken)

func insert_battery(battery: Battery) -> void:
	if is_instance_valid(battery.hold_owner):
		battery.hold_owner.inv_manager.unhold_object()
	
	battery.battery_slot = self
	battery.freeze = true
	battery.global_transform = battery_transform.global_transform
	battery.reparent(self)
	insert_sfx.play()
	powered = true

func battery_taken(node: Node) -> void:
	if node is Battery:
		powered = false

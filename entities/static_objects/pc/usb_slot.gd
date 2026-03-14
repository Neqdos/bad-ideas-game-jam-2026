extends Area3D
class_name USBSlot


@onready var usb_slot_info_label: ObjectInfoLabel = %USBSlotInfoLabel

@export var usb_extracting: PopupResource


var tween: Tween

var is_empty: bool = true

func insert(usb: USBDrive) -> void:
	if is_instance_valid(usb.hold_owner): usb.hold_owner.inv_manager.unhold_object()
	
	is_empty = false
	
	usb.freeze = true
	usb.set_collision_layer_value(4, false)
	usb.global_transform = global_transform
	
	DesktopManager.show_popup(usb_extracting)
	
	await DesktopManager.usb_extracting_finished
	
	DesktopManager.add_file_to_desktop(usb.file_res)
	
	usb.freeze = false
	usb.set_collision_layer_value(4, true)
	
	is_empty = true

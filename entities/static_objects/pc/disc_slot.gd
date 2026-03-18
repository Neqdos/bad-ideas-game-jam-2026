extends Area3D
class_name DiscSlot


@onready var disc_slot_info_label: ObjectInfoLabel = %DiscSlotInfoLabel

@export var disc_extracting: PopupResource

const DEFAULT_INFO_LABEL_TEXT: String = "Disc slot"
const EXTRACTING_INFO_LABEL_TEXT: String = "Extracting..."

var tween: Tween

var is_empty: bool = true

func _ready() -> void:
	disc_slot_info_label.info = DEFAULT_INFO_LABEL_TEXT

func insert(disc: Disc) -> void:
	if is_instance_valid(disc.hold_owner): disc.hold_owner.inv_manager.unhold_object()
	
	is_empty = false
	
	disc.freeze = true
	disc.set_collision_layer_value(4, false)
	disc.global_transform = global_transform
	
	DesktopManager.show_popup(disc_extracting)
	
	disc_slot_info_label.info = EXTRACTING_INFO_LABEL_TEXT
	
	await DesktopManager.disc_extracting_finished
	
	DesktopManager.add_file_to_desktop(disc.file_res)
	
	disc.freeze = false
	disc.set_collision_layer_value(4, true)
	
	is_empty = true
	
	disc_slot_info_label.info = DEFAULT_INFO_LABEL_TEXT

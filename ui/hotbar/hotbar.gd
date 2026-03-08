extends Control

@export var player: PlayerBody

@onready var held_object_slot: PanelContainer = %HeldObjectSlot
@onready var held_object_texture: TextureRect = %HeldObjectTexture
@onready var held_object_label: Label = %HeldObjectLabel


# Not sure if a hotbar like this is actually needed, might be deleted later.

func _ready() -> void:
	player.inv_manager.held_object_changed.connect(sync_hotbar)
	
	SignalManager.change_player_ui_visibility.connect(_on_change_hotbar_visibility)
	
	sync_hotbar()

func _on_change_hotbar_visibility(visibility: bool) -> void:
	visible = visibility

func sync_hotbar() -> void:
	if is_instance_valid(player.inv_manager.held_object):
		held_object_slot.visible = true
		held_object_texture.texture = player.inv_manager.held_object.obj_resource.texture
		held_object_label.text = player.inv_manager.held_object.obj_resource.name
	else:
		held_object_slot.visible = false

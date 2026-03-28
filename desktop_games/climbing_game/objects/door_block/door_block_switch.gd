extends Node2D
class_name DoorBlockSwitch

@export var on_layer: TileMapLayer
@export var off_layer: TileMapLayer

@export var state: bool = true

func _ready() -> void:
	on_layer.enabled = state
	off_layer.enabled = !state

func switch() -> void:
	state = !state
	on_layer.enabled = state
	off_layer.enabled = !state

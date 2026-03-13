extends Node2D

@export var bg: ColorRect
@export var file_tile: FileTile

func _ready() -> void:
	file_tile.file_placed.connect(_on_file_placed)

func _on_file_placed() -> void:
	bg.color = Color(0.141, 0.44, 0.74, 1.0)
	file_tile.visible = false

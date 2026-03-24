extends Node2D
class_name PaintingPaint

signal correct_paint()
signal incorrect_paint()

const CORRECT_PAINT: Array[Array] = [[0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0], [1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1], [2, 2, 2, 2, 2, 2, 2, 2], [2, 2, 2, 2, 2, 2, 2, 2], [3, 3, 3, 3, 3, 3, 3, 3], [3, 3, 3, 3, 3, 3, 3, 3]]

@onready var tilemap: TileMapLayer = %Tilemap

func _ready() -> void:
	DesktopManager.paint_tiles_changed.connect(_on_paint_tiles_changed)

func _on_paint_tiles_changed() -> void:
	if DesktopManager.paint_tiles == CORRECT_PAINT:
		correct_paint.emit()
		print("Correct")
	else:
		incorrect_paint.emit()
	
	for y: int in range(8):
		for x: int in range(8):
			tilemap.set_cell(Vector2i(x, y), DesktopManager.paint_tiles[y][x], Vector2i(0, 0))

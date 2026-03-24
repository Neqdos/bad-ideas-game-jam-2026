extends Node2D

@onready var white_button: Button = %WhiteButton
@onready var red_button: Button = %RedButton
@onready var green_button: Button = %GreenButton
@onready var blue_button: Button = %BlueButton

@onready var paint_tile_map_layer: TileMapLayer = %PaintTileMapLayer

const MIN_TILE: Vector2i = Vector2i(-6, -4)
const MAX_TILE: Vector2i = Vector2i(1, 3)

var selected_tile: int = 0

var is_mouse_pressed: bool = false

@onready var exportbutton: Button = %EXPORTBUTTON

func _ready() -> void:
	white_button.pressed.connect(func(): selected_tile = 0)
	red_button.pressed.connect(func(): selected_tile = 1)
	green_button.pressed.connect(func(): selected_tile = 2)
	blue_button.pressed.connect(func(): selected_tile = 3)
	
	exportbutton.pressed.connect(func():
		print(DesktopManager.paint_tiles)
		)
	
	DesktopManager.paint_tiles.clear()
	for y: int in range(8):
		DesktopManager.paint_tiles.append([])
		for x: int in range(8):
			DesktopManager.paint_tiles[y].append(0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_mouse_pressed:
		paint(paint_tile_map_layer.to_local(get_global_mouse_position()))
	elif event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				paint(paint_tile_map_layer.to_local(get_global_mouse_position()))
				is_mouse_pressed = true
		else:
			is_mouse_pressed = false

func paint(pos: Vector2) -> void:
	var tile_pos: Vector2i = paint_tile_map_layer.local_to_map(pos)
	
	if tile_pos.x < MIN_TILE.x or tile_pos.x > MAX_TILE.x: return
	if tile_pos.y < MIN_TILE.y or tile_pos.y > MAX_TILE.y: return
	
	paint_tile_map_layer.set_cell(tile_pos, selected_tile, Vector2i(0, 0))
	update_tile_in_desktop_manager(tile_pos - MIN_TILE)

func update_tile_in_desktop_manager(pos: Vector2i) -> void:
	var tile: int = DesktopManager.paint_tiles[pos.y][pos.x]
	if tile != selected_tile:
		DesktopManager.paint_tiles[pos.y][pos.x] = selected_tile
		DesktopManager.paint_tiles_changed.emit()

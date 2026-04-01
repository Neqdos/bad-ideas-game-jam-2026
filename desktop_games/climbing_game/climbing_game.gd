extends Node2D

@onready var transition: ClimbingTransition = %Transition

@onready var holyfish_file_tile: FileTile = %HolyfishFileTile
@onready var tutorial_sign_3: Sprite2D = %TutorialSign3

@onready var paint_tilemap_layer: TileMapLayer = %PaintTilemapLayer

const PAINT_OFFSET: Vector2i = Vector2i(55, -30)
@onready var victor_sprite: VictorSprite = %VictorSprite

func _ready() -> void:
	DesktopManager.climbing_input_lock.emit(true)
	transition.do_transition(true, .01)
	
	DesktopManager.window_grab_focus.connect(_on_window_grab_focus)
	
	holyfish_file_tile.file_placed.connect(_on_holyfish_file_placed)
	
	DesktopManager.paint_tiles_changed.connect(_on_paint_tiles_changed)
	
	DesktopManager.climbing_victor_hit.connect(_on_victor_hit)

func _on_window_grab_focus(window: DesktopWindow) -> void:
	if window is FileWindow and window.app_viewport.get_child(0) == self:
		DesktopManager.disconnect("window_grab_focus", _on_window_grab_focus)
		
		transition.do_transition(false, 1.0)
		
		await DesktopManager.climbing_transition_finished
		
		DesktopManager.climbing_input_lock.emit(false)

func _on_victor_hit() -> void:
	victor_sprite.death()
	await victor_sprite.died
	DesktopManager.victors_defeated += 1

# FIXME: putting this here but remember to make fishing game stats to normal
# and bomb wall back to enabled

func _on_holyfish_file_placed() -> void:
	holyfish_file_tile.queue_free()
	
	DesktopManager.has_wings = true
	tutorial_sign_3.visible = true

# TODO: add the bird here.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("crouch"):
		$ClimbingPlayer.global_position = get_global_mouse_position()

func _on_paint_tiles_changed() -> void:
	for y: int in range(8):
		for x: int in range(8):
			paint_tilemap_layer.set_cell(Vector2i(x, y) + PAINT_OFFSET, DesktopManager.paint_tiles[y][x], Vector2i(0, 0))

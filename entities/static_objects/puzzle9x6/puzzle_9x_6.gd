extends Node3D

@onready var battery_slot: BatterySlot = %BatterySlot

@onready var tiles: Node3D = %Tiles

const TILE_9X_6_SCENE = preload("uid://dgvoxcs7iwdgo")

func _ready() -> void:
	battery_slot.powered_changed.connect(_on_battery_slot_powered_changed)
	
	DesktopManager.desktop_icon_added.connect(create_tile)
	
	await get_tree().create_timer(1.0).timeout
	
	for desktop_icon: DesktopIcon in DesktopManager.desktop_icon_container.get_children():
		create_tile(desktop_icon)

func _on_battery_slot_powered_changed() -> void:
	for tile: Tile9x6 in tiles.get_children():
		tile.check_visibility(battery_slot.powered)

func create_tile(desktop_icon: DesktopIcon) -> void:
	var new_tile: Tile9x6 = TILE_9X_6_SCENE.instantiate()
	new_tile.desktop_icon = desktop_icon
	new_tile.check_visibility(battery_slot.powered)
	tiles.add_child(new_tile)
	new_tile.sync_position()
	

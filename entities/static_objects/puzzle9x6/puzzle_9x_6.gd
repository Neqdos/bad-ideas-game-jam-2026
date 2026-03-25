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
	if battery_slot.powered:
		pass
	else:
		pass

func create_tile(desktop_icon: DesktopIcon) -> void:
	var new_tile: Tile9x6 = TILE_9X_6_SCENE.instantiate()
	new_tile.desktop_icon = desktop_icon
	tiles.add_child(new_tile)
	new_tile.sync_position()

extends Node3D

@export var pc: PCObject
@export var player: PlayerBody

@onready var ambient_sound: AudioStreamPlayer = %AmbientSound
@onready var hammer_spot_marker: Marker3D = %HammerSpotMarker
@onready var objects_node: Node3D = %ObjectsNode

@onready var transition: Transition = %Transition
@onready var door_bell: AudioStreamPlayer3D = %DoorBell

const HAMMER_SCENE_PATH: String = "uid://drq818rlsgnl0"
const STORE_POPUP = preload("uid://cpml7x8aucyak")
const ENDING_SCREEN = preload("uid://d1e8x3j8136hw")

var first_time_gravity_change: bool = true

func _ready() -> void:
	ambient_sound.finished.connect(func(): ambient_sound.play())
	
	DesktopManager.spawn_hammer.connect(_on_spawn_hammer)
	DesktopManager.gravity_changed.connect(_on_gravity_changed)
	
	await get_tree().create_timer(.1).timeout
	
	pc.object_interact_action.interacted.emit(player)
	
	await get_tree().create_timer(.5).timeout
	
	transition.do_transition(false, 1.0)
	
	DesktopManager.game_end.connect(_on_game_end)

func _on_spawn_hammer() -> void:
	var hammer_scene: PackedScene = load(HAMMER_SCENE_PATH)
	
	var new_hammer: RigidObject = hammer_scene.instantiate()
	objects_node.add_child(new_hammer)
	new_hammer.global_position = hammer_spot_marker.global_position
	door_bell.play()

func _on_gravity_changed() -> void:
	if !first_time_gravity_change: return
	first_time_gravity_change = false
	
	await get_tree().create_timer(randf_range(60.0, 120.0)).timeout
	
	DesktopManager.show_popup(STORE_POPUP)

func _on_game_end() -> void:
	transition.do_transition(true, 2.0)
	await transition.transition_finished
	get_tree().change_scene_to_packed(ENDING_SCREEN)

extends Node2D

@onready var transition: ClimbingTransition = %Transition

@onready var holyfish_file_tile: FileTile = %HolyfishFileTile

func _ready() -> void:
	DesktopManager.climbing_input_lock.emit(true)
	transition.do_transition(true, .01)
	
	DesktopManager.window_grab_focus.connect(_on_window_grab_focus)
	
	holyfish_file_tile.file_placed.connect(_on_holyfish_file_placed)

func _on_window_grab_focus(window: DesktopWindow) -> void:
	if window is FileWindow and window.app_viewport.get_child(0) == self:
		DesktopManager.disconnect("window_grab_focus", _on_window_grab_focus)
		
		transition.do_transition(false, 1.0)
		
		await DesktopManager.climbing_transition_finished
		
		DesktopManager.climbing_input_lock.emit(false)

func _on_holyfish_file_placed() -> void:
	holyfish_file_tile.queue_free()
	
	DesktopManager.has_wings = true

# TODO: add the bird here.

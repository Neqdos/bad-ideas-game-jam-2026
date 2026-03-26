extends Node2D

@onready var transition: ClimbingTransition = %Transition

func _ready() -> void:
	DesktopManager.climbing_input_lock.emit(true)
	transition.do_transition(true, .01)
	
	DesktopManager.window_grab_focus.connect(_on_window_grab_focus)

func _on_window_grab_focus(window: DesktopWindow) -> void:
	if window is FileWindow and window.app_viewport.get_child(0) == self:
		DesktopManager.disconnect("window_grab_focus", _on_window_grab_focus)
		
		transition.do_transition(false, 1.0)
		
		await DesktopManager.climbing_transition_finished
		
		DesktopManager.climbing_input_lock.emit(false)

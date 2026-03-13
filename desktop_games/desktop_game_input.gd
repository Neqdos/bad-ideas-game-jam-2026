@abstract
extends Node
class_name DesktopGameInput

@export var app_node: Node2D

var did_reset: bool = false

## This should be placed in a physics_process or process function
func check_viewport() -> bool:
	var viewport: SubViewport = app_node.get_parent()
	if viewport.gui_disable_input:
		if !did_reset: reset()
		return true
	did_reset = false
	return false

## This should have did_reset = true
@abstract
func reset() -> void
